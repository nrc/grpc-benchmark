# sftp id_rsa
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup component add rustfmt
apt install gcc
apt install g++
apt install cmake
curl -O https://dl.google.com/go/go1.12.linux-amd64.tar.gz
tar xvf go1.12.linux-amd64.tar.gz
chown -R root:root ./go
mv go /usr/local
export GOPATH=$HOME/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
mkdir version-controlled
cd version-controlled
git clone git@github.com:pingcap/grpc.git --depth 1
git clone git@github.com:nrc/prost.git
cd prost
git pull origin qol
cd ..
git clone git@github.com:nrc/kvproto.git
cd kvproto
git pull origin prost
cd ..
git clone git@github.com:nrc/kvproto-build.git
cd kvproto-build
git reset HEAD~2 --hard
git pull origin prost
cd ..
git clone git@github.com:nrc/grpc-rs.git
cd grpc-rs
git pull origin prost
git submodule update --init --recursive
cargo build -p benchmark --release
cd ..
cd grpc/tools/gce
./create_linux_kokoro_performance_worker.sh
cd ../..
git submodule update --init --recursive
python2.7 tools/run_tests/run_performance_tests.py -l rust

cd ../grpc-rs
git checkout 182c8a0a9bd06ccf2bac8847b9fcbe12187de4e6
cargo build -p benchmark --release
cd ../grpc
python2.7 tools/run_tests/run_performance_tests.py -l rust
