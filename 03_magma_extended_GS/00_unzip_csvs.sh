cd /mnt/disk1/data/GS_233IDs/zips

gsutil -m cp gs://genetics-portal-dev-sumstats/tmp/yt4-filtered-GS-233-zip/* .

lf=$(ls ./*zip)

for f in $lf
do

echo $f
unzip $f 

done