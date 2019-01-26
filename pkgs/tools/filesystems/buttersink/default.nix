{ lib, python2 }:

python2.pkgs.buildPythonApplication rec {
  pname = "buttersink";
  version = "0.6.9";

  src = python2.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "a797b6e92ad2acdf41e033c1368ab365aa268f4d8458b396a5770fa6c2bc3f54";
  };

  propagatedBuildInputs = with python2.pkgs; [ boto crcmod psutil ];

  # No tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Synchronise btrfs snapshots";
    longDescription = ''
      ButterSink is like rsync, but for btrfs subvolumes instead of files,
      which makes it much more efficient for things like archiving backup
      snapshots. It is built on top of btrfs send and receive capabilities.
      Sources and destinations can be local btrfs file systems, remote btrfs
      file systems over SSH, or S3 buckets.
    '';
    homepage = https://github.com/AmesCornish/buttersink/wiki;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
