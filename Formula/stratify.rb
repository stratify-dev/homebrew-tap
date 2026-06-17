class Stratify < Formula
  desc "Stratify: polyglot codebase-intelligence CLI"
  homepage "https://github.com/stratify-dev/stratify"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.3.1/stratify-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4f2f36c9d42bf6d6791c58c95912823bc75b70010bad85b278888ed89540791c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.3.1/stratify-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7fc589c87b462206f062493a8b915cf2b3af5db0ec13a27481499eccbc40badb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.3.1/stratify-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3a3d25e762cf726f7da07d605d87b98f6d860999b021aefdc9156af6c1a39092"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.3.1/stratify-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19f8dee6631d6c9144c7d5f069faf991364e70814324b491406a1eb5f795805b"
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
