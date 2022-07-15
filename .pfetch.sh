# create tmp dir
TMP=.temp
mkdir -p $TMP 2>/dev/null

git clone https://github.com/dylanaraps/pfetch.git $1/pfetch
cd $1/pfetch
make install

# clean tmp dir
rm -rf $TMP
