class Stratify < Formula
  desc "Stratify: polyglot codebase-intelligence CLI"
  homepage "https://github.com/stratify-dev/stratify"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.7.0/stratify-cli-aarch64-apple-darwin.tar.xz"
      sha256 "961fe9a5a316555ac9a18524005bccc9d8b49b58c4199ac73a6b14e8200070d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.7.0/stratify-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5f4ee104c6db85883a47b6d1b45f68d777a47dab149ce81cd19488b859bf51de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.7.0/stratify-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "120f6c72aaefcbcdd6a6f86c3e40f887ea3bfe0e15e9f3ee45dff705282a0797"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stratify-dev/stratify/releases/download/v0.7.0/stratify-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51a156991c7b72218d0b3c838f280c5d14c49e058f0c1bf3638fc67286ff3620"
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
