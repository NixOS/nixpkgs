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

std::optional<std::vector<std::byte>> get_key(std::string type,
                                              std::optional<std::string> otp_path,
                                              std::optional<std::string> seeprom_path) {
  if (type == "mlc") {
    if (!otp_path)
      throw std::runtime_error("missing otp");
    std::unique_ptr<OTP> otp(OTP::LoadFromFile(*otp_path));
    return otp->GetMLCKey();
  } else if (type == "usb") {
    if (!otp_path || !seeprom_path)
      throw std::runtime_error("missing seeprom");
    std::unique_ptr<OTP> otp(OTP::LoadFromFile(*otp_path));
    std::unique_ptr<SEEPROM> seeprom(SEEPROM::LoadFromFile(*seeprom_path));
    return seeprom->GetUSBKey(*otp);
  } else if (type == "plain") {
    return std::nullopt;
  } else {
    throw std::runtime_error("unexpected type");
  }
}

int main(int argc, char* argv[]) {
  try {
    std::string input_path, type, inject_file, inject_path;
    std::optional<std::string> seeprom_path, otp_path;

    try {
      boost::program_options::options_description desc("options");
      desc.add_options()("help", "produce help message");

      desc.add_options()("image", boost::program_options::value<std::string>(&input_path)->required(),
                         "wfs image file")(
          "type", boost::program_options::value<std::string>(&type)->default_value("usb")->required(),
          "file type (usb/mlc/plain)")("otp", boost::program_options::value<std::string>(),
                                       "otp file (for usb/mlc types)")(
          "seeprom", boost::program_options::value<std::string>(), "seeprom file (for usb type)");

      desc.add_options()("inject-file", boost::program_options::value<std::string>(&inject_file)->required(),
                         "file to inject")("inject-path",
                                           boost::program_options::value<std::string>(&inject_path)->required(),
                                           "wfs file path to replace");

      boost::program_options::variables_map vm;
      boost::program_options::store(boost::program_options::parse_command_line(argc, argv, desc), vm);

      if (vm.count("help")) {
        std::cout << "usage: wfs-file-injector --image <wfs image> [--type <type>]" << std::endl
                  << "                         [--otp <path> [--seeprom <path>]]" << std::endl
                  << "                         --inject-file <file to inject> --inject-path <file path in wfs>"
                  << std::endl
                  << std::endl;
        std::cout << desc << std::endl;
        return 0;
      }

      boost::program_options::notify(vm);

      // Fill arguments
      if (vm.count("otp"))
        otp_path = vm["otp"].as<std::string>();
      if (vm.count("seeprom"))
        seeprom_path = vm["seeprom"].as<std::string>();

      if (type != "usb" && type != "mlc" && type != "plain")
        throw boost::program_options::error("Invalid input type (valid types: usb/mlc/plain)");
      if (type != "plain" && !otp_path)
        throw boost::program_options::error("Missing --otp");
      if (type == "usb" && !seeprom_path)
        throw boost::program_options::error("Missing --seeprom");

    } catch (const boost::program_options::error& e) {
      std::cerr << "Error: " << e.what() << std::endl;
      std::cerr << "Use --help to display program options" << std::endl;
      return 1;
    }

    auto key = get_key(type, otp_path, seeprom_path);

    std::ifstream input_file(inject_file, std::ios::binary | std::ios::in);
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

    auto device = std::make_shared<FileDevice>(input_path, 9, 0, false);
    Wfs::DetectDeviceSectorSizeAndCount(device, key);
    auto file = Wfs(device, key).GetFile(inject_path);
    if (!file) {
      std::cerr << "Error: Didn't find file " << inject_path << " in wfs" << std::endl;
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
