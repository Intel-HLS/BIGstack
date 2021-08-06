
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $BASEDIR

sed -i '37i\    cpu: "1"' $BASEDIR/Qc.wdl
sed -i 's|cpu: "16"|cpu: "4"|g'  $BASEDIR/Alignment.wdl
sed -i '417i\    cpu: "2"' $BASEDIR/BamProcessing.wdl
sed -i '78s/#preemptible: preemptible_tries/cpu: "2"/' $BASEDIR/Qc.wdl
sed -i '143i\    cpu: "2"' $BASEDIR/BamProcessing.wdl
sed -i 's|cpu: "1"|cpu: "2"|g'  $BASEDIR/BamProcessing.wdl
sed -i '270i\    cpu: "2"' $BASEDIR/Qc.wdl
sed -i '65i\    cpu: "2"' $BASEDIR/Utilities.wdl
sed -i '256i\    cpu: "2"' $BASEDIR/BamProcessing.wdl
sed -i '350i\    cpu: "2"' $BASEDIR/BamProcessing.wdl
sed -i '322i\    cpu: "2"' $BASEDIR/BamProcessing.wdl
sed -i '127i\    cpu: "2"' $BASEDIR/Qc.wdl
sed -i '182i\    cpu: "2"' $BASEDIR/Qc.wdl
sed -i '317i\    cpu: "2"' $BASEDIR/Qc.wdl
sed -i '573i\    cpu: "2"' $BASEDIR/Qc.wdl
sed -i '153s/cpu: "1"/#cpu: "1"/'  $BASEDIR/Utilities.wdl
sed -i '154i\    cpu: "2"' $BASEDIR/Utilities.wdl
sed -i '413i\    cpu: "2"' $BASEDIR/Qc.wdl
sed -i '453i\    cpu: "2"' $BASEDIR/Qc.wdl
sed -i '498i\    cpu: "2"' $BASEDIR/Qc.wdl
sed -i '114i\    cpu: "2"' $BASEDIR/Utilities.wdl
sed -i '72s/cpu: "1"/cpu: "2"/'  $BASEDIR/GermlineVariantDiscovery.wdl
sed -i '167i\    cpu: "2"' $BASEDIR/GermlineVariantDiscovery.wdl
sed -i '617i\    cpu: "2"' $BASEDIR/Qc.wdl
sed -i '653i\    cpu: "2"' $BASEDIR/Qc.wdl

