class StratifyCli < Formula
  desc "Stratify: polyglot codebase-intelligence CLI"
  homepage "https://github.com/stratify-dev/stratify"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.1.0/stratify-cli-aarch64-apple-darwin.tar.xz"
      sha256 "18fe5e73ae65094e19dc11665c40b8d554fd987fdaa6e6bda2f9b02f7ff7772b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.1.0/stratify-cli-x86_64-apple-darwin.tar.xz"
      sha256 "68de7a7b4bc6e0267386606f306ec6d43dd555ca8c54079597e375b6e2ef9e9b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.1.0/stratify-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f27b1b3385bb663ad85e673a953d35ab4a4cb5168a5ac556c78671e83acfe471"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.1.0/stratify-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19f7aa8c0d7988728b544c97b1786272022bafd8f58c334f99f743c9abd7bd56"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "stratify" if OS.mac? && Hardware::CPU.arm?
    bin.install "stratify" if OS.mac? && Hardware::CPU.intel?
    bin.install "stratify" if OS.linux? && Hardware::CPU.arm?
    bin.install "stratify" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
