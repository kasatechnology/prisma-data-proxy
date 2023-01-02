import { DMMF } from "@prisma/client/runtime";
import { PrismaClient } from "@prisma/client/scripts/default-index";
// import { ExpressMiddlewareOptions } from "@apollo/server/express4";
import { ApolloServerOptions } from "@apollo/server";
import { makeTypeDefs } from "./makeTypeDefs";
import { makeResolver } from "./makeResolver";

export const makeServerConfig = (
  dmmf: DMMF.Document,
  db: PrismaClient
): ApolloServerOptions<any> => {
  return {
    typeDefs: makeTypeDefs(dmmf),
    resolvers: makeResolver(dmmf, db),
  };
};
