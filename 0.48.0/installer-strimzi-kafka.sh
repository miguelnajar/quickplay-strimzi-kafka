#!/bin/bash

# Check if a command was provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [deploy|update|delete]"
    exit 1
fi

case "$1" in
    deploy)
        echo "🚀 Starting Kafka cluster deployment..."

        # Define variables for the values you want to replace
        cp -R template/* .
        declare -A ary        # associative array to store name-value pairs
        pat='^([^[:space:]]+)[[:space:]]*=[[:space:]]*"([^"]+)"$'
        while IFS= read -r line; do
            if [[ $line =~ $pat ]]; then
                ary[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]}"
            fi
        done < variables.list

        # Clean up working directory with clean files.
        cp -R template/* .

        # Gotta love "sed"
        sed -i "s/Kafka_Connect_Image/${ary[Kafka_Connect_Image]}/g" kafkaconnect/kafka-connect.yaml
        sed -i "s/Cluster_Name/${ary[Cluster_Name]}/g" kafka-persistent.yaml
        sed -i "s/Cluster_Name/${ary[Cluster_Name]}/g"  kafkaconnect/kafka-connect.yaml
        sed -i "s/Kafka_Replicas/${ary[Kafka_Replicas]}/g" kafka-persistent.yaml
        sed -i "s/Kafka_Insync_Replicas/${ary[Kafka_Insync_Replicas]}/g" kafka-persistent.yaml
        sed -i "s/Nodepool_Key/${ary[Nodepool_Key]}/g" kafka-persistent.yaml
        sed -i "s/Nodepool_Key/${ary[Nodepool_Key]}/g" kafkaconnect/kafka-connect.yaml
        sed -i "s/Nodepool_Value/${ary[Nodepool_Value]}/g" kafka-persistent.yaml
        sed -i "s/Nodepool_Value/${ary[Nodepool_Value]}/g" kafkaconnect/kafka-connect.yaml
        sed -i "s/Kafka_NS/${ary[Kafka_NS]}/g" install/cluster-operator/*
        sed -i "s/Nodepool_Key/${ary[Nodepool_Key]}/g" install/cluster-operator/060-Deployment-strimzi-cluster-operator.yaml
        sed -i "s/Nodepool_Value/${ary[Nodepool_Value]}/g" install/cluster-operator/060-Deployment-strimzi-cluster-operator.yaml

        # Now that the YAML is updated, apply it
        kubectl create ns ${ary[Kafka_NS]}
        kubectl create -f install/cluster-operator -n ${ary[Kafka_NS]}
        sleep 5
        kubectl apply -f kafka-persistent.yaml -n ${ary[Kafka_NS]}
        sleep 5
        kubectl apply -f kafkaconnect/kafka-connect.yaml -n ${ary[Kafka_NS]}

        echo "✅ Deployment complete."
        ;;

    update)
        echo "🔄 Updating Kafka cluster operator..."
        cp -R template/* .
        declare -A ary        # associative array to store name-value pairs
        pat='^([^[:space:]]+)[[:space:]]*=[[:space:]]*"([^"]+)"$'
        while IFS= read -r line; do
            if [[ $line =~ $pat ]]; then
                ary[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]}"
            fi
        done < variables.list

        # Clean up working directory with clean files.
        cp -R template/* .

        # Gotta love "sed"
        sed -i "s/Kafka_Connect_Image/${ary[Kafka_Connect_Image]}/g" kafkaconnect/kafka-connect.yaml
        sed -i "s/Cluster_Name/${ary[Cluster_Name]}/g" kafka-persistent.yaml
        sed -i "s/Cluster_Name/${ary[Cluster_Name]}/g"  kafkaconnect/kafka-connect.yaml
        sed -i "s/Kafka_Replicas/${ary[Kafka_Replicas]}/g" kafka-persistent.yaml
        sed -i "s/Kafka_Insync_Replicas/${ary[Kafka_Insync_Replicas]}/g" kafka-persistent.yaml
        sed -i "s/Nodepool_Key/${ary[Nodepool_Key]}/g" kafka-persistent.yaml
        sed -i "s/Nodepool_Key/${ary[Nodepool_Key]}/g" kafkaconnect/kafka-connect.yaml
        sed -i "s/Nodepool_Value/${ary[Nodepool_Value]}/g" kafka-persistent.yaml
        sed -i "s/Nodepool_Value/${ary[Nodepool_Value]}/g" kafkaconnect/kafka-connect.yaml
        sed -i "s/Kafka_NS/${ary[Kafka_NS]}/g" install/cluster-operator/*
        sed -i "s/Nodepool_Key/${ary[Nodepool_Key]}/g" install/cluster-operator/060-Deployment-strimzi-cluster-operator.yaml
        sed -i "s/Nodepool_Value/${ary[Nodepool_Value]}/g" install/cluster-operator/060-Deployment-strimzi-cluster-operator.yaml

        # Now that the YAML is updated, apply it
        #kubectl create ns ${ary[Kafka_NS]}
        kubectl replace -f install/cluster-operator -n ${ary[Kafka_NS]}
        sleep 5
        echo "✅ Updating the cluster operator."
        ;;

    delete)
        echo "🗑️ Deleting Kafka cluster..."
        # Add your deletion commands here.
        # You'll need to read the namespace from variables.list for deletion.
        # Example:
        # declare -A ary
        # while IFS= read -r line; do if [[ $line =~ $pat ]]; then ary[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]}"; fi; done < variables.list
        # kubectl delete -f kafkaconnect/kafka-connect.yaml -n ${ary[Kafka_NS]}
        # kubectl delete -f kafka-persistent.yaml -n ${ary[Kafka_NS]}
        # kubectl delete -f install/cluster-operator -n ${ary[Kafka_NS]}
        # kubectl delete ns ${ary[Kafka_NS]}
        echo "✅ Deletion complete."
        ;;

    *)
        echo "❌ Invalid command: $1"
        echo "Usage: $0 [deploy|update|delete]"
        exit 1
        ;;
esac

exit
