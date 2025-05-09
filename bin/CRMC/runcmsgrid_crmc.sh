#!/bin/sh

fail_exit() { echo "$@"; exit 1; }

reinstall_crmc(){
    echo "Compiling CRMC"
    cd ${LHEWORKDIR}/${CRMCDIR}
    source /cvmfs/sft.cern.ch/lcg/views/LCG_107/x86_64-el8-gcc11-opt/setup.sh # using LCG for now, FIXME   
    
    CMAKE=$([[ $(cmake --version | grep -cE *"n ([3-9]\.)")>0 ]] && echo "cmake" || echo "cmake3")
    ${CMAKE} -S . -B BUILD CMAKE_ARGS_REPLACE
    ${CMAKE} --build BUILD --target install --parallel $(nproc)
}

run_crmc(){
    echo "*** STARTING PRODUCTION ***"
    cd ${LHEWORKDIR}/${CRMCDIR}/install/bin
    cp ${LHEWORKDIR}/${CRMCDIR}/install/etc/crmc.param .
    sed -i "s/MinDecayLength  1./MinDecayLength  100./" crmc.param
    
    generator=GENERATOR_REPLACE
    
    if [ "$generator" = 'eposlhcr_pO' ]; then
      ./crmc -m 0 -i 1 -p 6800 -I 80160 -P -3400 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'eposlhcr_Op' ]; then
      ./crmc -m 0 -i 80160 -p 3400 -I 1 -P -6800 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'eposlhcr_OO' ]; then
      ./crmc -m 0 -i 80160 -p 5360 -I 80160 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'eposlhcr_NeNe' ]; then
      ./crmc -m 0 -i 100200 -p 5360 -I 100200 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    
    elif [ "$generator" = 'eposnhs_pO' ]; then
      ./crmc -m 1 -i 1 -p 6800 -I 80160 -P -3400 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'eposnhs_Op' ]; then
      ./crmc -m 1 -i 80160 -p 3400 -I 1 -P -6800 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'eposnhs_OO' ]; then
      ./crmc -m 1 -i 80160 -p 5360 -I 80160 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'eposnhs_NeNe' ]; then
      ./crmc -m 1 -i 100200 -p 5360 -I 100200 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe

    elif [ "$generator" = 'sibyll_pO' ]; then
      ./crmc -m 6 -i 1 -p 6800 -I 80160 -P -3400 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'sibyll_Op' ]; then
      ./crmc -m 6 -i 80160 -p 3400 -I 1 -P -6800 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'sibyll_OO' ]; then
      ./crmc -m 6 -i 80160 -p 5360 -I 80160 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'sibyll_NeNe' ]; then
      ./crmc -m 6 -i 100200 -p 5360 -I 100200 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe

    elif [ "$generator" = 'dpmjetIII.19_pO' ]; then
      ./crmc -m 12 -i 1 -p 6800 -I 80160 -P -3400 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'dpmjetIII.19_Op' ]; then
      ./crmc -m 12 -i 80160 -p 3400 -I 1 -P -6800 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'dpmjetIII.19_OO' ]; then
      ./crmc -m 12 -i 80160 -p 5360 -I 80160 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'dpmjetIII.19_NeNe' ]; then
      ./crmc -m 12 -i 100200 -p 5360 -I 100200 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe

    elif [ "$generator" = 'qgsjetIII_pO' ]; then
      echo unpack qgsdat-III.lzma
      xz --format=lzma --decompress ${LHEWORKDIR}/${CRMCDIR}/install/share/crmc/qgsdat-III.lzma
      ./crmc -m 13 -i 1 -p 6800 -I 80160 -P -3400 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'qgsjetIII_Op' ]; then
      echo unpack qgsdat-III.lzma
      xz --format=lzma --decompress ${LHEWORKDIR}/${CRMCDIR}/install/share/crmc/qgsdat-III.lzma
      ./crmc -m 13 -i 80160 -p 3400 -I 1 -P -6800 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'qgsjetIII_OO' ]; then
      echo unpack qgsdat-III.lzma
      xz --format=lzma --decompress ${LHEWORKDIR}/${CRMCDIR}/install/share/crmc/qgsdat-III.lzma
      ./crmc -m 13 -i 80160 -p 5360 -I 80160 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
    elif [ "$generator" = 'qgsjetIII_NeNe' ]; then
      echo unpack qgsdat-III.lzma
      xz --format=lzma --decompress ${LHEWORKDIR}/${CRMCDIR}/install/share/crmc/qgsdat-III.lzma
      ./crmc -m 13 -i 100200 -p 5360 -I 100200 -P -5360 -o lhe -n $nevt -s $rnum -f cmsgrid_final.lhe
      
    fi
    mv cmsgrid_final.lhe ${LHEWORKDIR}/cmsgrid_final.lhe
    echo "***MC GENERATION COMPLETED***"
}

echo "   ______________________________________     "
echo "         Running crmc                    "
echo "   ______________________________________     "

nevt=${1}
echo "%MSG-CRMC number of events requested = $nevt"

rnum=${2}
echo "%MSG-CRMC random seed used for the run = $rnum"

ncpu=${3}
echo "%MSG-CRMC number of cputs for the run = $ncpu"

LHEWORKDIR=`pwd -P`

use_gridpack_env=false # using LCG for now, FIXME
if [ "$4" = false ]; then
    use_gridpack_env=$4
fi

if [ "$use_gridpack_env" = true ]; then
    if [[ "$5" == *[_]* ]]; then
        scram_arch_version=${5}
    else
        scram_arch_version=SCRAM_ARCH_VERSION_REPLACE
    fi
    echo "%MSG-CRMC SCRAM_ARCH version = $scram_arch_version"

    if [[ "$6" == CMSSW_* ]]; then
        cmssw_version=${6}
    else
        cmssw_version=CMSSW_VERSION_REPLACE
    fi
    echo "%MSG-CRMC CMSSW version = $cmssw_version"

    export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
    source $VO_CMS_SW_DIR/cmsset_default.sh

    eval `scramv1 unsetenv -sh`
    export SCRAM_ARCH=${scram_arch_version}
    scramv1 project CMSSW ${cmssw_version}
    cd ${cmssw_version}/src
    eval `scramv1 runtime -sh`
fi

cd $LHEWORKDIR

CRMCDIR=CRMCDIR_REPLACE

#Install CRMC generator locally
reinstall_crmc

#Run CRMC generator
run_crmc

#Perform test
xmllint --stream --noout ${LHEWORKDIR}/cmsgrid_final.lhe > /dev/null 2>&1; test $? -eq 0 || fail_exit "xmllint integrity check failed on cmsgrid_final.lhe"

echo "Output ready with cmsgrid_final.lhe at $LHEWORKDIR"
echo "End of job on "`date`
exit 0
