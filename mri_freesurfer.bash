##########input info
#id_=A125933
#input_file=/data2/zhiyu/rawdata/mri/rawdata/*_$id_/*/T2_SPACE*
#dir_work_path=$dir_work/$id_

#dir_work=/data2/zhiyu/rawdata/mri/rawdata_test/
dir_work=$(pwd)

list_id="A126692	A126713 "

for i in $list_id
    do
    id_=$i
    input_file=/data/zhiyu/data_pipeline/MRI/freesurfer/freesurf_GV_batch2/rawdata/*_$id_/*/T1_MPR*
    dir_work_path=$dir_work/$id_
    echo "
    export FREESURFER_HOME=/home/zhiyu/data/software/FreeSurfer/freesurfer/
    source /home/zhiyu/data/software/FreeSurfer/freesurfer/SetUpFreeSurfer.sh
    ##########input info

    mkdir -p ${dir_work_path}
    cd $dir_work_path
    export SUBJECTS_DIR=$dir_work_path

     dcm2niix -f $id_  -o  $dir_work_path  $input_file  

    recon-all -i $id_.nii  -s bert -all 
    python2 /home/zhiyu/data/software/FreeSurfer/freesurfer/bin/asegstats2table --subjects bert --meas volume --tablefile aseg_stats.txt
    python2 /home/zhiyu/data/software/FreeSurfer/freesurfer/bin/aparcstats2table --subjects bert --hemi rh --meas thickness --tablefile aparc_stats.txt
    sed -e 's/^/$id_\t/g' aseg_stats.txt  > aseg_stats_add.txt
    sed -e 's/^/$id_\t/g' aparc_stats.txt  > aparc_stats_add.txt
    ###########finished

    " > $id_.sh
done

cat */*aseg_stats_add.txt > SCD2_aseg_stats_add_all.txt
cat */*aparc_stats_add.txt > SCD2_aparc_stats_add_all.txt
