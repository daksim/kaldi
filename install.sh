cd tools/
make -j 4

cd ../src/
./configure --shared
make depend -j 4
make -j 4