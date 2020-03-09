ARG VERSION=latest

# Modules
FROM redisai/redisai:latest as redisai
FROM redislabs/redisearch:latest as redisearch
FROM redislabs/redisgraph:latest as redisgraph
FROM redislabs/redistimeseries:latest as redistimeseries
FROM redislabs/rejson:latest as rejson
FROM redislabs/rebloom:latest as rebloom

# Runtime
FROM bitnami/redis:${VERSION}

ENV LD_LIBRARY_PATH /usr/lib/redis/modules
ENV REDISGRAPH_DEPS libgomp1

USER root
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends ${REDISGRAPH_DEPS};

COPY --from=redisai ${LD_LIBRARY_PATH}/*.so* ${LD_LIBRARY_PATH}/
COPY --from=redisearch ${LD_LIBRARY_PATH}/redisearch.so ${LD_LIBRARY_PATH}/
COPY --from=redisgraph ${LD_LIBRARY_PATH}/redisgraph.so ${LD_LIBRARY_PATH}/
COPY --from=redistimeseries ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=rejson ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=rebloom ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/

USER 1001
