git clone https://github.com/sewenew/redis-plus-plus.git

cd redis-plus-plus

mkdir build

cd build

cmake -DREDIS_PLUS_PLUS_CXX_STANDARD=11 ..

make

sudo make install

cd ..
