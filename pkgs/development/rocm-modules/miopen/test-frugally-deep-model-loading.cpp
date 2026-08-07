#include <fdeep/fdeep.hpp>
#include <iostream>
#include <filesystem>
#include <vector>
#include <string>

int main() {
    std::vector<std::string> model_files;
    std::string src_dir = std::getenv("SRC_DIR") ? std::getenv("SRC_DIR") : ".";

    // collect *tn.model files except _metadata
    try {
        for (const auto& entry : std::filesystem::recursive_directory_iterator(src_dir)) {
            if (entry.is_regular_file()) {
                std::string path = entry.path().string();
                if (path.find("tn.model") != std::string::npos && path.find("_metadata.") == std::string::npos) {
                    model_files.push_back(path);
                }
            }
        }
    } catch (const std::exception& e) {
        std::cerr << "Error scanning directory: " << e.what() << std::endl;
        return 1;
    }

    if (model_files.empty()) {
        std::cout << "No *.tn.model files found in " << src_dir << std::endl;
        return 1;
    }

    std::cout << "Found " << model_files.size() << " model files to test" << std::endl;

    int failed_count = 0;
    for (const auto& model_file : model_files) {
        std::cout << "Loading: " << model_file << " ... ";
        std::cout.flush();

        try {
            const auto model = fdeep::load_model(model_file);
            std::cout << "OK" << std::endl;
        } catch (const std::exception& e) {
            std::cout << "FAILED: " << e.what() << std::endl;
            failed_count++;
        }
    }

    if (failed_count > 0) {
        std::cerr << "\n" << failed_count << " out of " << model_files.size()
                    << " models failed to load" << std::endl;
        return 1;
    }

    std::cout << "\nAll " << model_files.size() << " models loaded successfully!" << std::endl;
    return 0;
}
