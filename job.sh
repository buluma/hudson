# CHECK DEVICE NAME
ZIPDEVICE=$(echo $LUNCH | sed s#cm_##g | sed s#-userdebug##g | sed s#-eng##g)
if [ -z "$ZIPDEVICE" ]
then
  echo "EMPTY DEVICE"
  exit 1
fi
export ZIPDEVICE=$ZIPDEVICE

if [ -z "$HOME" ]
then
  echo HOME not in environment, guessing...
  export HOME=$(awk -F: -v v="$USER" '{if ($1==v) print $6}' /etc/passwd)
fi

cd $WORKSPACE
mkdir -p ../android
cd ../android
OLDWORKSPACE=$WORKSPACE
export WORKSPACE=$PWD
export

if [ ! -d hudson ]
then
  git clone git://github.com/androidarmv6/hudson.git -b master
fi

cd hudson
## Get rid of possible local changes
git reset --hard
git pull -s resolve
cd ..

# BUILD
cp -fr hudson/build.sh build.sh
exec ./build.sh
rm -fr $OLDWORKSPACE/archive
cp -a $WORKSPACE/archive $OLDWORKSPACE
