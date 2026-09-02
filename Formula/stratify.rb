class Stratify < Formula
  desc "Stratify: polyglot codebase-intelligence CLI"
  homepage "https://github.com/stratify-dev/stratify"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.5.0/stratify-cli-aarch64-apple-darwin.tar.xz"
      sha256 "cb84c9e2d8b6f14a050159d2a88a76c04fe27abc8170460f80ded1a36a934a66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.5.0/stratify-cli-x86_64-apple-darwin.tar.xz"
      sha256 "95c91101564583481fcd44288e1eec1389948134fa98d41b6b0ee9b7e730b84c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.5.0/stratify-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c84251adaa0166b4157a50b33f0bfdf6c71154575fe5dd5291137ef6428fd6c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.5.0/stratify-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "31cc94dd8b961ab57b19df2cd71e6957299ec2acd2b3680ff937a16952bdb6e9"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "stratify"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "stratify"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "stratify"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "stratify"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
