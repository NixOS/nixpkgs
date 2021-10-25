export GOPATH=$(mktemp -d /tmp/aliyunfcli.XXXXXX)
mkdir -p $GOPATH/src/github.com/aliyun
cd $GOPATH/src/github.com/aliyun
git clone https://github.com/aliyun/fcli
cd fcli
git checkout 996ceb142c237d7010c58e349decd7e4ed96c117
git apply /path/to/your/local/nixpkgs/pkgs/tools/admin/aliyun-fcli/uuiddep.patch
glide install
go mod init github.com/aliyun/fcli
go mod tidy
go mod vendor
go build
vgo2nix save
ls $GOPATH/src/github.com/aliyun/fcli/deps.nix
