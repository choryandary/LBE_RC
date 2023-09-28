function GEN_Batch(batchfile,newPath,folderName)

    fprintf(batchfile, '%s%s%s%s \n','cd ',newPath,"\",folderName) ;
    fprintf(batchfile,'%s ','"C:\LSDYNA\program\ls-dyna_smp_s_R11_1_0_winx64_ifort160.exe"');
    fprintf(batchfile,'%s%s%s%s%s','i=',newPath,"\",folderName,"\");
    fprintf(batchfile,'%s','LBE_Set.k');
    fprintf(batchfile,' %s %s \n','ncpu=8','memory=2000m');
    fprintf(batchfile,'%s\n','dir/w');
end