# begin
@log.trace("Started executing 'flint-util:file:validation:write.rb' flintbit...")
begin
    # Flintbit Input Parameters
    connector_name = @input.get('connector_name') # Name of the HTTP Connector
    action = @input.get('action')                 # Action
    file_path = @input.get('file')                # File Name and Location
    data = @input.get('data')                     # Data to be written to the File

    connector_name = 'File Connector' if connector_name.nil? || connector_name.empty?
    action = 'write' if action.nil? || action.empty?
    if file_path.nil? || file_path.empty?
        file_path = Dir.pwd + '/flintbox/example/hello.rb'
    end
    data = ' Welcome to Flint !! ' if data.nil? || data.empty?

    @log.info("Flintbit input parameters are, connector name : #{connector_name} | action : #{action} |file_path : #{file_path} |
    file_content : #{data}")

    @log.trace("Calling #{connector_name}..")
    response = @call.connector(connector_name)
                    .set('action', action)
                    .set('file', file_path)
                    .set('data', data)
                    .sync

    # File Connector Response Meta Parameters
    response_exitcode = response.exitcode # Exit status code
    response_message = response.message   # Execution status messages

    # File Connector Response Parameters
    response_file = response.get('file')  # File, data is written to
    response_body = response.get('body')  # Response Body, data written to the file

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @log.info("File :: #{response_file} | Data written to the file :: #{response_body}")
        @output.set('result', response_file)
        @output.set('content', response_body)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.exit(1, response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'flint-util:file:validation:write.rb' flintbit...")
# end
