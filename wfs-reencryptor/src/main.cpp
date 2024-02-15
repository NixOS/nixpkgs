/*
 * Copyright (C) 2024 koolkdev
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

#include <boost/algorithm/string/case_conv.hpp>
#include <boost/algorithm/string/trim.hpp>
#include <boost/program_options.hpp>
#include <cstdio>
#include <filesystem>
#include <format>
#include <fstream>
#include <iostream>
#include <memory>
#include <vector>

#include <wfslib/blocks_device.h>
#include <wfslib/wfslib.h>
// TOOD: Public header?
#include "../../wfslib/src/area.h"
#include "../../wfslib/src/device_encryption.h"
#include "../../wfslib/src/free_blocks_allocator.h"

class ReencryptorBlocksDevice final : public BlocksDevice {
 public:
  struct BlockInfo {
    uint32_t data_size;
    uint32_t size_in_blocks;
    uint32_t iv;
    bool encrypted;
  };
  ReencryptorBlocksDevice(const std::shared_ptr<Device>& device, const std::span<std::byte>& key)
      : BlocksDevice(device, key) {}
  ~ReencryptorBlocksDevice() final override = default;

  bool ReadBlock(uint32_t block_number,
                 uint32_t size_in_blocks,
                 const std::span<std::byte>& data,
                 const std::span<const std::byte>& hash,
                 uint32_t iv,
                 bool encrypt,
                 bool check_hash) override {
    assert(check_hash);
    assert(blocks_.find(block_number) == blocks_.end());
    bool res = BlocksDevice::ReadBlock(block_number, size_in_blocks, data, hash, iv, encrypt, check_hash);
    if (!res && block_number == 0)
      return res;
    if (res)
      blocks_[block_number] = BlockInfo{static_cast<uint32_t>(data.size()), size_in_blocks, iv, encrypt};
    else
      bad_blocks_[block_number] = BlockInfo{static_cast<uint32_t>(data.size()), size_in_blocks, iv, encrypt};
    return res;
  }

  const std::map<uint32_t, BlockInfo>& blocks() { return blocks_; }

  void Reencrypt(std::shared_ptr<BlocksDevice> output_device) {
    for (const auto& [block_number, info] : blocks()) {
      std::vector<std::byte> data(info.data_size, std::byte{0});
      BlocksDevice::ReadBlock(block_number, info.size_in_blocks, data, {}, info.iv, info.encrypted,
                              /*check_hash=*/false);
      output_device->WriteBlock(block_number, info.size_in_blocks, data, {}, info.iv, info.encrypted,
                                /*recalculate_hash=*/false);
    }
  }

 private:
  std::map<uint32_t, BlockInfo> blocks_;
  std::map<uint32_t, BlockInfo> bad_blocks_;
};

std::string inline prettify_path(const std::filesystem::path& path) {
  return "/" + path.generic_string();
}

void exploreDir(const std::shared_ptr<Directory>& dir, const std::filesystem::path& path, bool shadow = false) {
  if (!shadow && dir->IsQuota()) {
    // It is an area, iterate its allocator
    auto area = dir->area();
    try {
      auto allocator = throw_if_error(area->GetFreeBlocksAllocator());
      for (const auto& [tree_block_number, free_tree] : allocator->tree()) {
        for (const auto& free_tree_per_size : free_tree) {
          for (const auto& [block_number, blocks_count] : free_tree_per_size) {
            std::ignore = block_number;
            std::ignore = blocks_count;
          }
        }
      }
    } catch (const WfsException& e) {
      std::cout << std::format("Error: Failed to explore {} free blocks allocator ({})\n", prettify_path(path),
                               e.what());
    }
    auto shadow_dir_1 = area->GetShadowDirectory1();
    if (shadow_dir_1.has_value()) {
      exploreDir(*shadow_dir_1, path / ".shadow_dir_1", true);
    } else {
      std::cout << std::format("Error: Failed to explore {} shadow dir 1 ({})\n", prettify_path(path),
                               WfsException(shadow_dir_1.error()).what());
    }
    auto shadow_dir_2 = area->GetShadowDirectory1();
    if (shadow_dir_2.has_value()) {
      exploreDir(*shadow_dir_1, path / ".shadow_dir_1", true);
    } else {
      std::cout << std::format("Error: Failed to explore {} shadow dir 2 ({})\n", prettify_path(path),
                               WfsException(shadow_dir_2.error()).what());
    }
  }
  for (auto [name, item_or_error] : *dir) {
    auto const npath = path / name;
    try {
      auto item = throw_if_error(item_or_error);
      if (item->IsDirectory())
        exploreDir(std::dynamic_pointer_cast<Directory>(item), npath);
      else if (item->IsFile()) {
        auto file = std::dynamic_pointer_cast<File>(item);
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
          to_read -= static_cast<size_t>(read);
        }
      }
    } catch (const WfsException& e) {
      std::cout << std::format("Error: Failed to explore {} ({})\n", prettify_path(npath), e.what());
    }
  }
}

int main(int argc, char* argv[]) {
  try {
    boost::program_options::options_description desc("Allowed options");
    std::string wfs_path;
    desc.add_options()("help", "produce help message")("input", boost::program_options::value<std::string>(),
                                                       "input file")(
        "output", boost::program_options::value<std::string>(), "output file")(
        "input-otp", boost::program_options::value<std::string>(), "input otp file")(
        "input-seeprom", boost::program_options::value<std::string>(), "input seeprom file (required if usb)")(
        "output-otp", boost::program_options::value<std::string>(), "output otp file")(
        "output-seeprom", boost::program_options::value<std::string>(), "output seeprom file (required if usb)")(
        "mlc", "device is mlc (default: device is usb)")("usb", "device is usb");

    boost::program_options::variables_map vm;
    boost::program_options::store(boost::program_options::parse_command_line(argc, argv, desc), vm);
    boost::program_options::notify(vm);

    bool bad = false;
    if (!vm.count("input")) {
      std::cerr << "Missing input file (--input)" << std::endl;
      bad = true;
    }
    if (!vm.count("output")) {
      std::cerr << "Missing output file (--output)" << std::endl;
      bad = true;
    }
    if (!vm.count("input-otp")) {
      std::cerr << "Missing input otp file (--input-otp)" << std::endl;
      bad = true;
    }
    if (!vm.count("output-otp")) {
      std::cerr << "Missing output otp file (--output-otp)" << std::endl;
      bad = true;
    }
    if ((!vm.count("input-seeprom") && !vm.count("mlc"))) {
      std::cerr << "Missing input seeprom file (--input-seeprom)" << std::endl;
      bad = true;
    }
    if ((!vm.count("output-seeprom") && !vm.count("mlc"))) {
      std::cerr << "Missing output seeprom file (--output-seeprom)" << std::endl;
      bad = true;
    }
    if (vm.count("mlc") + vm.count("usb") > 1) {
      std::cerr << "Can't specify both --mlc and --usb" << std::endl;
      bad = true;
    }
    if (vm.count("help") || bad) {
      std::cout << "Usage: wfs-reencryptor --input <input file> --output <output file> --input-otp <input otp path> "
                   "--output-otp "
                   "<output otp path> [--input-seeprom <input seeprom path> --output-seeprom <outpu seeprom path>] "
                   "[--mlc] [--usb]"
                << std::endl;
      std::cout << desc << "\n";
      return 1;
    }

    std::vector<std::byte> input_key, output_key;
    std::unique_ptr<OTP> input_otp, output_otp;
    // open otp
    try {
      input_otp.reset(OTP::LoadFromFile(vm["input-otp"].as<std::string>()));
      output_otp.reset(OTP::LoadFromFile(vm["output-otp"].as<std::string>()));
    } catch (std::exception& e) {
      std::cerr << "Failed to open OTP: " << e.what() << std::endl;
      return 1;
    }

    if (vm.count("mlc")) {
      // mlc
      input_key = input_otp->GetMLCKey();
      output_key = output_otp->GetMLCKey();
    } else {
      // usb
      std::unique_ptr<SEEPROM> input_seeprom, output_seeprom;
      try {
        input_seeprom.reset(SEEPROM::LoadFromFile(vm["input-seeprom"].as<std::string>()));
        output_seeprom.reset(SEEPROM::LoadFromFile(vm["output-seeprom"].as<std::string>()));
      } catch (std::exception& e) {
        std::cerr << "Failed to open SEEPROM: " << e.what() << std::endl;
        return 1;
      }
      input_key = input_seeprom->GetUSBKey(*input_otp);
      output_key = output_seeprom->GetUSBKey(*output_otp);
    }
    auto input_device = std::make_shared<FileDevice>(vm["input"].as<std::string>(), 9);
    Wfs::DetectDeviceSectorSizeAndCount(input_device, input_key);
    auto output_device =
        std::make_shared<FileDevice>(vm["output"].as<std::string>(), input_device->Log2SectorSize(),
                                     input_device->SectorsCount(), /*read_only=*/false, /*create=*/true);
    std::cout << "Exploring blocks..." << std::endl;
    auto reencryptor = std::make_shared<ReencryptorBlocksDevice>(input_device, input_key);
    exploreDir(throw_if_error(Wfs(reencryptor).GetRootArea()->GetRootDirectory()), {});
    std::cout << std::format("Found {} blocks! Reencrypting...\n", reencryptor->blocks().size());
    reencryptor->Reencrypt(std::make_shared<BlocksDevice>(output_device, output_key));
    std::cout << "Done!" << std::endl;
  } catch (std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
  }
  return 0;
}
