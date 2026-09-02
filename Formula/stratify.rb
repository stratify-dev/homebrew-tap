class Stratify < Formula
  desc "Stratify: polyglot codebase-intelligence CLI"
  homepage "https://github.com/stratify-dev/stratify"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.6.0/stratify-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d523e3e0233c00a467a8174fee809a598df0cf87c824bdf74a8ff5f17cd54b70"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.6.0/stratify-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5247be640ea68a4453ca01b18184657805779c4c094201426856273b62d2fced"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.6.0/stratify-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5e636fed7d30720468bffee81cbccd76830aa42862b461551dbe40c10e112a99"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.6.0/stratify-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e3f31e278f0164470ec3d749471d053e973f1b53377be60887ad4b632993c10"
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
