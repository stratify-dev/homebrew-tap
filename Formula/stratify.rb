class Stratify < Formula
  desc "Stratify: polyglot codebase-intelligence CLI"
  homepage "https://github.com/stratify-dev/stratify"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.4.0/stratify-cli-aarch64-apple-darwin.tar.xz"
      sha256 "556a61b9784ccda647096cc8510a44c4cf78f4cc892ef29f0cf3003391b6a086"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.4.0/stratify-cli-x86_64-apple-darwin.tar.xz"
      sha256 "55b91cd9fad826e01b035f77456573150b71bcac9144ede081d2c31ef4e31038"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.4.0/stratify-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4499f399d1e2ced2d307d7d3de68e7c73bce0c037468cd27481ba584af3fdb0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.4.0/stratify-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "58f61cfc910c4d9b3eda8c9795dd9b18fc3da303511bd0653e069f7333ab2dc2"
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
