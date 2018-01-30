{
linux_py_27_cpu = {
  url = "https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.5.0-cp27-none-linux_x86_64.whl";
  sha256 = "15xiazbkcyhcpym80vwyzr8nvwabjwbzwgmqnwpixnas0mg43bp3";
};
linux_py_35_cpu = {
  url = "https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.5.0-cp35-cp35m-linux_x86_64.whl";
  sha256 = "1bpn66ky3nigcxfsyhm2vjdvk3q853flq8p6gy8mgcq5dnnrvi2w";
};
linux_py_36_cpu = {
  url = "https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.5.0-cp36-cp36m-linux_x86_64.whl";
  sha256 = "1g2hrwnjrqv567hdd2a8hfj7d0f2smfy78acwf89nwakcaazqv3q";
};
linux_py_27_gpu = {
  url = "https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.5.0-cp27-none-linux_x86_64.whl";
  sha256 = "1xkdzbvxkdndhpb06gw87vcisi7206c401zw9wnfaaabamwynjvd";
};
linux_py_35_gpu = {
  url = "https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.5.0-cp35-cp35m-linux_x86_64.whl";
  sha256 = "0hxw3daf5m3scnvmkm6943wrzx4xxafn827achxjjknmbxr379sz";
};
linux_py_36_gpu = {
  url = "https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.5.0-cp36-cp36m-linux_x86_64.whl";
  sha256 = "1qc0hr20wk409gfd023b2j667vgci2f9hm0p7c0is27mp6vmi2zq";
};
mac_py_2_cpu = {
  url = "https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-1.5.0-py2-none-any.whl";
  sha256 = "0irwp59wg1gaknn4x9w6srbdqfv15ds8glg1kk7pfkx8d1sr3kgj";
};
mac_py_3_cpu = {
  url = "https://storage.googleapis.com/tensorflow/mac/cpu/tensorflow-1.5.0-py3-none-any.whl";
  sha256 = "1mapv45n9wmgcq3i3im0pv0gmhwkxw5z69nsnxb1gfxbj1mz5h9m";
};
}

# This file was generated using the following script
# version=1.5.0
# hashfile=tf${version}-hashes.nix
# rm -f $hashfile
# echo "{" >> $hashfile
# for sys in "linux" "mac"; do
#     for tfpref in "cpu/tensorflow" "gpu/tensorflow_gpu"; do
#         for pykind in "py2-none-any" "py3-none-any" "cp27-none-linux_x86_64" "cp35-cp35m-linux_x86_64" "cp36-cp36m-linux_x86_64"; do
#             if [ $sys == "mac" ]; then
#                [[ $pykind =~ py.* ]] && [[ $tfpref =~ cpu.* ]]
#                result=$?
#                pyver=${pykind:2:1}
#                flavour=cpu
#             else
#                [[ $pykind =~ .*linux.* ]]
#                result=$?
#                pyver=${pykind:2:2}
#                flavour=${tfpref:0:3}
#             fi
#             if [ $result == 0 ]; then
#                 url=https://storage.googleapis.com/tensorflow/$sys/$tfpref-$version-$pykind.whl
#                 hash=$(nix-prefetch-url $url)
#                 echo "${sys}_py_${pyver}_${flavour} = {" >> $hashfile
#                 echo "  url = \"$url\";" >> $hashfile
#                 echo "  sha256 = \"$hash\";" >> $hashfile
#                 echo "};" >> $hashfile
#             fi
#         done
#     done
# done

# echo "}" >> $hashfile
