# hail_example
Here is an example for running a script `hail_example.py` on google cloud dataproc cluster.

## Pre-request
To be able to run this, you should have a google cloud billing account, and are able to setup a google project, under which you can create google buckets and spin up a google data proc cluster. You also need to install gcloud tools [https://cloud.google.com/sdk/gcloud/], as many steps need to interact directly with google cloud.

Clone this repo, and put the src directory under your path:

```
export PATH=hail_example/src:$PATH
```

1) Download example data
Run `src/get_example_input.py`. This script is from the hail website [https://hail.is/docs/stable/tutorials/hail-overview.html#Check-for-tutorial-data-or-download-if-necessary]. This will download two files `1kg.vds` and `1kg_annotations.txt` to a `data` directory.
Upload those files to your google bucket:
```
gsutil -m cp data/* gs://my/bucket/
```

2) Change input of `src/hail_example.py`
Update google bucket link of `input`, `output`, `annot` and `qc_results` variable in the `src/hail_example.py` script to enable it to find the right path of files.

3) Spin up a google dataproc cluster

Use this command:
```
gcloud dataproc clusters create <mycluster> \
  --zone us-central1-f \
  --master-machine-type n1-standard-8 \
  --master-boot-disk-size 100 \
  --num-workers 2 \
  --worker-machine-type n1-standard-8 \
  --worker-boot-disk-size 75 \
  --num-worker-local-ssds 0 \
  --num-preemptible-workers 2 \
  --image-version 1.1 \
  --project <your google project ID> \
  --properties "spark:spark.driver.extraJavaOptions=-Xss4M,spark:spark.executor.extraJavaOptions=-Xss4M,spark:spark.driver.memory=45g,spark:spark.driver.maxResultSize=30g,spark:spark.task.maxFailures=20,spark:spark.kryoserializer.buffer.max=1g,hdfs:dfs.replication=1" \
  --initialization-actions gs://hail-common/hail-init.sh,gs://hail-common/init_notebook.py
```
This command will start up a dataproc cluster with 1 master node and 2 worker node.

4) After cluster is up, submit a job via:
```
pyhail-submit <cluster name> src/hail_example.py
```
This script is from the hail team. It's a wrapper over gcloud command to submit jobs to a dataproc cluster. 
There will be screen prompts indicating progress of the analysis.

5) Once the compute is done, kill the cluster in the google cloud console.

6) Notes: cloudtools [https://github.com/Nealelab/cloudtools] wrapped many gcloud functions and made the starting, connecting and job submitting steps easy. There are other commands used to monitor job process and diagnose potential issues. Commands can be found here: `src/gcloud_commands.sh`.  
