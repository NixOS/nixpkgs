/*
 * Copyright (C) 2022 koolkdev
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

#include <boost/program_options.hpp>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <memory>
#include <vector>

#include <wfslib/wfslib.h>

int main(int argc, char* argv[]) {
  try {
    boost::program_options::options_description desc("Allowed options");
    std::string wfs_path;
    desc.add_options()("help", "produce help message")("image", boost::program_options::value<std::string>(),
                                                       "wfs image file")(
        "inject-file", boost::program_options::value<std::string>(), "file to inject")(
        "inject-path", boost::program_options::value<std::string>(), "wfs file path to replace")(
        "otp", boost::program_options::value<std::string>(), "otp file")(
        "seeprom", boost::program_options::value<std::string>(), "seeprom file (required if usb)")(
        "mlc", "device is mlc (default: device is usb)")("usb", "device is usb");

    boost::program_options::variables_map vm;
    boost::program_options::store(boost::program_options::parse_command_line(argc, argv, desc), vm);
    boost::program_options::notify(vm);

    bool bad = false;
    if (!vm.count("image")) {
      std::cerr << "Missing wfs image file (--image)" << std::endl;
      bad = true;
    }
    if (!vm.count("inject-file")) {
      std::cerr << "Missing file to inject (--inject-file)" << std::endl;
      bad = true;
    }
    if (!vm.count("inject-path")) {
      std::cerr << "Missing wfs file path (--inject-path)" << std::endl;
      bad = true;
    }
    if (!vm.count("otp")) {
      std::cerr << "Missing otp file (--otp)" << std::endl;
      bad = true;
    }
    if ((!vm.count("seeprom") && !vm.count("mlc"))) {
      std::cerr << "Missing seeprom file (--seeprom)" << std::endl;
      bad = true;
    }
    if (vm.count("mlc") + vm.count("usb") > 1) {
      std::cerr << "Can't specify both --mlc and --usb" << std::endl;
      bad = true;
    }
    if (vm.count("help") || bad) {
      std::cout << "Usage: wfs-file-injector --image <wfs image> --inject-file <file to inject> --inject-path <file "
                   "path in wfs> --otp <opt path> [--seeprom <seeprom path>] [--mlc] [--usb]"
                << std::endl;
      std::cout << desc << "\n";
      return 1;
    }

    std::vector<std::byte> key;
    std::unique_ptr<OTP> otp;
    // open otp
    try {
      otp.reset(OTP::LoadFromFile(vm["otp"].as<std::string>()));
    } catch (std::exception& e) {
      std::cerr << "Failed to open OTP: " << e.what() << std::endl;
      return 1;
    }

    if (vm.count("mlc")) {
      // mlc
      key = otp->GetMLCKey();
    } else {
      // usb
      std::unique_ptr<SEEPROM> seeprom;
      try {
        seeprom.reset(SEEPROM::LoadFromFile(vm["seeprom"].as<std::string>()));
      } catch (std::exception& e) {
        std::cerr << "Failed to open SEEPROM: " << e.what() << std::endl;
        return 1;
      }
      key = seeprom->GetUSBKey(*otp);
    }
    std::ifstream input_file(vm["inject-file"].as<std::string>(), std::ios::binary | std::ios::in);
    if (input_file.fail()) {
      std::cerr << "Failed to open file to inject" << std::endl;
      return 1;
    }
    input_file.seekg(0, std::ios::end);
    if (static_cast<uint64_t>(input_file.tellg()) > SIZE_MAX) {
      std::cerr << "Error: File to inject too big" << std::endl;
      return 1;
    }
    size_t file_size = static_cast<size_t>(input_file.tellg());
    input_file.seekg(0, std::ios::beg);

    auto device = std::make_shared<FileDevice>(vm["image"].as<std::string>(), 9, 0, false);
    Wfs::DetectDeviceSectorSizeAndCount(device, key);
    auto file = Wfs(device, key).GetFile(vm["inject-path"].as<std::string>());
    if (!file) {
      std::cerr << "Error: Didn't find file " << vm["inject-path"].as<std::string>() << " in wfs" << std::endl;
      return 1;
    }
    if (file_size > file->SizeOnDisk()) {
      std::cerr << "Error: File to inject too big (wanted size: " << file_size
                << " bytes, available size: " << file->SizeOnDisk() << ")" << std::endl;
      return 1;
    }
    File::stream stream(file);
    std::vector<char> data(0x2000);
    size_t to_copy = file_size;
    while (to_copy > 0) {
      input_file.read(data.data(), std::min(data.size(), to_copy));
      auto read = input_file.gcount();
      if (read <= 0) {
        std::cerr << "Error: Failed to read file to inject" << std::endl;
        return 1;
      }
      stream.write(data.data(), read);
      to_copy -= static_cast<size_t>(read);
    }
    input_file.close();
    stream.close();
    if (file_size < file->Size()) {
      file->Resize(file_size);
    }
    std::cout << "Done!" << std::endl;
  } catch (std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
  return 0;
}
