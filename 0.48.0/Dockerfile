FROM quay.io/strimzi/kafka:0.48.0-kafka-4.1.0
USER root:root

RUN mkdir -p /opt/kafka/plugins/debezium
RUN mkdir -p /opt/kafka/plugins/snowflake
RUN mkdir -p /opt/kafka/plugins/couchbase
RUN mkdir -p /opt/kafka/plugins/pubsub
# Copy the properties files and jars
COPY ./plugins/debezium-connector-mysql/ /opt/kafka/plugins/debezium/
COPY ./plugins/snowflake-kafka-connector-2.2.2/ /opt/kafka/plugins/snowflake/
COPY ./plugins/couchbase-kafka-connect-couchbase-4.2.2/lib/ /opt/kafka/plugins/couchbase/
COPY ./plugins/pubsub-group-kafka-connector-1.2.0/ /opt/kafka/plugins/pubsub/
USER 1001
RUN export CLASSPATH="/opt/kafka/plugins/snowflake,/opt/kafka/plugins/debezium,/opt/kafka/plugins/couchbase,/opt/kafka/plugins/pubsub"
ENV CONNECT_PLUGIN_PATH="/opt/kafka/plugins/debezium,/opt/kafka/plugins/snowflake,/opt/kafka/plugins/couchbase,/opt/kafka/plugins/pubsub"