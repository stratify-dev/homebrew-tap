class Stratify < Formula
  desc "Stratify: polyglot codebase-intelligence CLI"
  homepage "https://github.com/stratify-dev/stratify"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.2.0/stratify-cli-aarch64-apple-darwin.tar.xz"
      sha256 "40d86457b23b1971f6304015e9081195d0ef199e0a248b5ca37ae7c55d780a86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.2.0/stratify-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bc31f5748f8d353dadca0900e68729189e660274fe7d96d248b4aee76ceb21fc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.2.0/stratify-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "063d387baa6121af6037fcd2a574701c26bbcb2d2cdc814a40284bcd899f38f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.2.0/stratify-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a4cde5aa04bbcea61274194dcf7762e76bf0ee62f0966765bb742157af47fde7"
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
