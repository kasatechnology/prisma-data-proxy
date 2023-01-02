FROM node:16.15-bullseye-slim as base

RUN apt-get update && apt-get install -y tini ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM base as builder

COPY package.json .
COPY tsconfig.json .
COPY src ./src
COPY prisma/schema.prisma ./prisma/schema.prisma

RUN npm install && npm run build

RUN npm exec prisma generate

FROM base

COPY --from=builder /node_modules ./node_modules
COPY --from=builder /package.json ./package.json
COPY --from=builder /dist ./dist

ENV PRISMA_SCHEMA_PATH=/node_modules/.prisma/client/schema.prisma

USER node

EXPOSE 8080

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "./dist/server.js"]