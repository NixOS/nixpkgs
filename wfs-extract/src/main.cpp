/*
 * Copyright (C) 2022 koolkdev
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

#include <boost/algorithm/string/trim.hpp>
#include <boost/program_options.hpp>
#include <cstdio>
#include <filesystem>
#include <format>
#include <fstream>
#include <iostream>
#include <memory>
#include <vector>

#include <wfslib/wfslib.h>

std::string inline prettify_path(const std::filesystem::path& path) {
  return "/" + path.generic_string();
}

void dumpdir(const std::filesystem::path& target,
             const std::shared_ptr<Directory>& dir,
             const std::filesystem::path& path,
             bool verbose) {
  auto target_dir = target;
  if (!path.empty())
    target_dir /= path;
  if (!std::filesystem::exists(target_dir)) {
    if (!std::filesystem::create_directories(target_dir)) {
      std::cerr << "Error: Failed to create directory " << target_dir.string() << std::endl;
      return;
    }
  }
  for (auto [name, item_or_error] : *dir) {
    auto const npath = path / name;
    try {
      auto item = throw_if_error(item_or_error);
      if (verbose)
        std::cout << "Dumping /" << npath.generic_string() << std::endl;
      if (item->IsDirectory()) {
        dumpdir(target, std::dynamic_pointer_cast<Directory>(item), npath, verbose);
      } else if (item->IsFile()) {
        auto file = std::dynamic_pointer_cast<File>(item);
        std::ofstream output_file((target / npath).string(), std::ios::binary | std::ios::out);
        size_t to_read = file->Size();
        File::stream stream(file);
        std::array<char, 0x2000> data;
        while (to_read > 0) {
          stream.read(data.data(), std::min(data.size(), to_read));
          auto read = stream.gcount();
          if (read <= 0) {
            std::cerr << "Error: Failed to read /" << npath.generic_string() << std::endl;
            break;
          }
          output_file.write(data.data(), read);
          to_read -= static_cast<size_t>(read);
        }
        output_file.close();
      }
    } catch (const WfsException& e) {
      std::cout << std::format("Error: Failed to dump {} ({})\n", prettify_path(npath), e.what());
    }
  }
}

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
    bool verbose;
    std::string input_path, output_path, type, dump_path;
    std::optional<std::string> seeprom_path, otp_path;

    try {
      boost::program_options::options_description desc("options");
      desc.add_options()("help", "produce help message");

      desc.add_options()("input", boost::program_options::value<std::string>(&input_path)->required(), "input file")(
          "type", boost::program_options::value<std::string>(&type)->default_value("usb")->required(),
          "file type (usb/mlc/plain)")("otp", boost::program_options::value<std::string>(),
                                       "otp file (for usb/mlc types)")(
          "seeprom", boost::program_options::value<std::string>(), "seeprom file (for usb type)");

      desc.add_options()("output", boost::program_options::value<std::string>(&output_path)->required(),
                         "ouput directory")("dump-path",
                                            boost::program_options::value<std::string>(&dump_path)->default_value("/"),
                                            "directory to dump (default: \"/\")")("verbose", "verbose output");
      boost::program_options::variables_map vm;
      boost::program_options::store(boost::program_options::parse_command_line(argc, argv, desc), vm);

      if (vm.count("help")) {
        std::cout << "usage: wfs-extract --input <input file> [--type <type>]" << std::endl
                  << "                   [--otp <path> [--seeprom <path>]]" << std::endl
                  << "                   [--dump-path <directory to dump>] [--verbose]" << std::endl
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

      verbose = vm.count("verbose");

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
    auto device = std::make_shared<FileDevice>(input_path, 9);
    Wfs::DetectDeviceSectorSizeAndCount(device, key);
    dump_path = std::filesystem::path(dump_path).generic_string();
    boost::trim_if(dump_path, boost::is_any_of("/"));
    auto dir = Wfs(device, key).GetDirectory(dump_path);
    if (!dir) {
      std::cerr << "Error: Didn't find directory " << dump_path << " in wfs" << std::endl;
      return 1;
    }
    std::cout << "Dumping..." << std::endl;
    dumpdir(std::filesystem::path(output_path), dir, dump_path, verbose);
    std::cout << "Done!" << std::endl;
  } catch (std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
  return 0;
}
