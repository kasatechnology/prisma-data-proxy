FROM node:16.15-bullseye-slim as base

RUN apt-get update && apt-get install -y tini ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

FROM base as builder

COPY example/gcp/package.json .
COPY example/gcp/yarn.lock .
COPY example/gcp/prisma/schema.prisma ./prisma/schema.prisma

RUN yarn install

RUN yarn prisma generate

FROM base

COPY --from=builder /node_modules ./node_modules
COPY --from=builder /package.json ./package.json

ENV PRISMA_SCHEMA_PATH=/node_modules/.prisma/client/schema.prisma

USER node

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["yarn", "pdp"]
