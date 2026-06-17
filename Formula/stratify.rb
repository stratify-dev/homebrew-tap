class Stratify < Formula
  desc "Stratify: polyglot codebase-intelligence CLI"
  homepage "https://github.com/stratify-dev/stratify"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.3.0/stratify-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d85796d5d28fda4267596c9b2ebcda5980dc8478a79602561a62255a6e38f638"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.3.0/stratify-cli-x86_64-apple-darwin.tar.xz"
      sha256 "161a95f769c2d19a943709c408fe8f3e86b3973fa234ae4b23923eec0f43a6c2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.3.0/stratify-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bcafd691c20d2f2becd09441015a47532f945784ffbf94aed6b65093ce0b54e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.3.0/stratify-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "878b4bf452021f8ef3c5760954c9be175904c776638b4245e663afa7f8d786b4"
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
