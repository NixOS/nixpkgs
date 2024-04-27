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
#include <fstream>
#include <iostream>
#include <memory>
#include <print>
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
      std::println(std::cerr, "Error: Failed to create directory {}", target_dir.string());
      return;
    }
  }
  for (auto [name, item_or_error] : *dir) {
    auto const npath = path / name;
    try {
      auto item = throw_if_error(item_or_error);
      if (verbose)
        std::println("Dumping /{}", npath.generic_string());
      if (item->is_directory()) {
        dumpdir(target, std::dynamic_pointer_cast<Directory>(item), npath, verbose);
      } else if (item->is_file()) {
        auto file = std::dynamic_pointer_cast<File>(item);
        std::ofstream output_file((target / npath).string(), std::ios::binary | std::ios::out);
        size_t to_read = file->Size();
        File::stream stream(file);
        std::array<char, 0x2000> data;
        while (to_read > 0) {
          stream.read(data.data(), std::min(data.size(), to_read));
          auto read = stream.gcount();
          if (read <= 0) {
            std::println(std::cerr, "Error: Failed to read /{}", npath.generic_string());
            break;
          }
          output_file.write(data.data(), read);
          to_read -= static_cast<size_t>(read);
        }
        output_file.close();
      }
    } catch (const WfsException& e) {
      std::println(std::cerr, "Error: Failed to dump {} ({})", prettify_path(npath), e.what());
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
    bool verbose, dump_usr_dir;
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
                                            "directory to dump (default: \"/\")")("verbose", "verbose output")(
          "dump-usr-dir", "skip wfs header and extract the /usr dir (recover from wfs corruptions)");
      boost::program_options::variables_map vm;
      boost::program_options::store(boost::program_options::parse_command_line(argc, argv, desc), vm);

      if (vm.count("help")) {
        std::println("usage: wfs-extract --input <input file> [--type <type>]");
        std::println("                   [--otp <path> [--seeprom <path>]]");
        std::println("                   [--dump-path <directory to dump>] [--verbose]");
        std::println("");
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
      dump_usr_dir = vm.count("dump-usr-dir");

      if (type != "usb" && type != "mlc" && type != "plain")
        throw boost::program_options::error("Invalid input type (valid types: usb/mlc/plain)");
      if (type != "plain" && !otp_path)
        throw boost::program_options::error("Missing --otp");
      if (type == "usb" && !seeprom_path)
        throw boost::program_options::error("Missing --seeprom");

    } catch (const boost::program_options::error& e) {
      std::println(std::cerr, "Error: {}", e.what());
      std::println(std::cerr, "Use --help to display program options");
      return 1;
    }

    auto key = get_key(type, otp_path, seeprom_path);
    auto device = std::make_shared<FileDevice>(input_path, 9);
    dump_path = std::filesystem::path(dump_path).generic_string();
    boost::trim_if(dump_path, boost::is_any_of("/"));

    // Recovery mode
    if (dump_usr_dir) {
      auto wfs_with_usr_dir = Recovery::OpenUsrDirectoryWithoutWfsDeviceHeader(device, key);
      if (!wfs_with_usr_dir.has_value()) {
        if (wfs_with_usr_dir.error() == WfsError::kInvalidWfsVersion) {
          std::println(std::cerr,
                       "Error: Didn't find directory at the expected location, either the /usr dir is also corrupted "
                       "or the keys are wrong");
        } else {
          throw WfsException(wfs_with_usr_dir.error());
        }
        return 1;
      }
      // Adjust the dump path, as our dir is /usr
      if (!dump_path.empty()) {
        if (dump_path == "usr") {
          dump_path = "";
        } else if (dump_path.starts_with("usr/")) {
          dump_path = dump_path.substr(4);
        } else {
          std::println(std::cerr, "Error: can only dump the /usr directory in this mode");
          return 1;
        }
      }
      auto dir = (*wfs_with_usr_dir)->GetDirectory(dump_path);
      if (!dir) {
        std::println(std::cerr, "Error: Didn't find directory /usr/{} in wfs", dump_path);
        return 1;
      }
      dumpdir(std::filesystem::path(output_path), dir, "usr/" + dump_path, verbose);
      std::println("Done!");
      return 0;
    }

    // Regular mode
    auto detection_result = Recovery::DetectDeviceParams(device, key);
    if (detection_result.has_value()) {
      if (*detection_result == WfsError::kInvalidWfsVersion)
        std::println(std::cerr, "Error: Incorrect WFS version, possible wrong keys");
      else
        throw WfsException(*detection_result);
      return 1;
    }
    auto dir = throw_if_error(WfsDevice::Open(device, key))->GetDirectory(dump_path);
    if (!dir) {
      std::println(std::cerr, "Error: Didn't find directory {} in wfs", dump_path);
      return 1;
    }
    std::println("Dumping...");
    dumpdir(std::filesystem::path(output_path), dir, dump_path, verbose);
    std::println("Done!");
  } catch (std::exception& e) {
    std::println(std::cerr, "Error: {}", e.what());
    return 1;
  }
  return 0;
}
