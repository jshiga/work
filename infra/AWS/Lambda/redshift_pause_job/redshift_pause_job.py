import json
import os
import boto3

REGION = os.environ['REGION']


def lambda_handler(event, context):
        
    # redshift client
    rs_client = boto3.client('redshift',region_name=REGION)
    rs_clusters = rs_client.describe_clusters()
    rs_clusters_status = [{"ClusterIdentifier":r['ClusterIdentifier'], "ClusterStatus":r['ClusterStatus']} for r in rs_clusters['Clusters']]

    for c in rs_clusters_status:
        if c['ClusterStatus'] != 'paused':
            try:
                response = rs_client.pause_cluster(ClusterIdentifier=c['ClusterIdentifier'])
                print(f"paused: {c['ClusterIdentifier']}")
            except Exception as e:
                print('error: ',e)

    print('redshift_pause_batch: all done')