Facter.add(:installed_sidecar_version) do
  setcode do
    command = '/usr/bin/graylog-collector-sidecar -version'
    version = ''

    begin
      version_string = Facter::Core::Execution.execute(command)
      Facter.debug("Got version #{version_string}")

      version = /^[^0-9]*([0-9.]*).*/.match(version_string)[1]
    rescue Facter::Core::Execution::ExecutionFailure => e
      Facter.log_exception(e)
      Facter.debug("Failed to run #{command}. Returning nothing.")
    end

    Facter.debug("Found version #{version}")

    version
  end
end
