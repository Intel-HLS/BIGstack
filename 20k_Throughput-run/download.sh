
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WARP_VERSION=v2.3.3
# To fetch latest use WARP_VERSION=develop
wget -nc -v -P $BASEDIR https://github.com/broadinstitute/warp/releases/download/WholeGenomeGermlineSingleSample_$WARP_VERSION/WholeGenomeGermlineSingleSample_$WARP_VERSION.wdl
wget -nc -v -P $BASEDIR https://github.com/broadinstitute/warp/releases/download/WholeGenomeGermlineSingleSample_$WARP_VERSION/WholeGenomeGermlineSingleSample_$WARP_VERSION.zip
#wget -nc -v -P $BASEDIR https://github.com/broadinstitute/warp/releases/download/WholeGenomeGermlineSingleSample_$/WholeGenomeGermlineSingleSample_$WARP_VERSION.options.json
