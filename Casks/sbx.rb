# Cask for sbx, the Azure Service Bus explorer. The source is private; github.com/Playron/sbx
# holds the releases, and the release workflow in the source repo rewrites the version and
# sha256 lines here on every release. Do not edit them by hand unless that workflow failed.
# Livecheck needs no block: Homebrew reads the GitHub releases from the url on its own.
cask "sbx" do
  version "0.2.0"
  sha256 "9e50713e807bd39fc137777b6f2e5af252ce3adbbfbc2304366e8901715a1ab8"

  url "https://github.com/Playron/sbx/releases/download/v#{version}/sbx-#{version}-osx-arm64.tar.gz"
  name "sbx"
  desc "Azure Service Bus explorer"
  homepage "https://github.com/Playron/sbx"

  depends_on arch: :arm64
  depends_on macos: ">= :monterey"

  app "Sbx.app"

  # The bundle is ad hoc signed, not notarised, so Gatekeeper would refuse it with the quarantine
  # flag Homebrew puts on downloads. Clearing it here does what the README otherwise asks the
  # user to do by hand. Goes away if the app ever gets Developer ID signing and notarisation.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Sbx.app"],
                   sudo: false
  end

  # Profiles, log and name cache. Connection strings live in the Keychain (service "sbx") and
  # are left alone; remove them from Keychain Access if you want them gone too.
  zap trash: "~/.local/share/sbx"
end
