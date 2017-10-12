### gcloud commands for start a cluster
# start a cluster: machine-type: n1-highmem-8, n1-standard-8
gcloud dataproc clusters create mycluster \
  --zone us-central1-f \
  --master-machine-type n1-standard-8 \
  --master-boot-disk-size 100 \
  --num-workers 2 \
  --worker-machine-type n1-standard-8 \
  --worker-boot-disk-size 75 \
  --num-worker-local-ssds 0 \
  --num-preemptible-workers 2 \
  --image-version 1.1 \
  --project gtex-genotype-qc \
  --properties "spark:spark.driver.extraJavaOptions=-Xss4M,spark:spark.executor.extraJavaOptions=-Xss4M,spark:spark.driver.memory=45g,spark:spark.driver.maxResultSize=30g,spark:spark.task.maxFailures=20,spark:spark.kryoserializer.buffer.max=1g,hdfs:dfs.replication=1" \
  --initialization-actions gs://hail-common/hail-init.sh,gs://hail-common/init_notebook.py

# submit a script to run in google cloud
./pyhail-submit <cluster name> <script path>

# resize
gcloud dataproc clusters update --num-preemptible-workers 2 mycluster

# copy to hadoop file system
gcloud dataproc jobs submit hadoop \
  --cluster mycluster \
  --jar file:///usr/lib/hadoop-mapreduce/hadoop-distcp.jar -m N gs://wgs8/vcfs/*bgz hdfs:///home/xiaoli

# access master node
gcloud compute ssh mycluster-m
connect_cluster.py --name mycluster
hdfs://mycluster-m/user/root/
gcloud compute copy-files

# monitoring logs
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
 --proxy-server="socks5://localhost:1080" \
 --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost" \
 --user-data-dir=/tmp

# hadoop system
http://my-master:8088/

# spark UI
localhost:4040

# jupyter
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
 --proxy-server="socks5://localhost:8123"

gcloud dataproc clusters diagnose

# start interactive cluster with cloud tools
# Github repo https://github.com/Nealelab/cloudtools
start_cluster.py --num-worker-local-ssds 0 -n mycluster
connect_cluster.py --name mycluster
submit_cluster.py --name mycluster <script name>

# n partitions
gsutil -m ls -r gs://<path to vds> | grep -c parquet$
