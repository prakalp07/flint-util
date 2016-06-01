# begin
@log.trace("Started executing 'flint-util:http:operation:get.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # mandatory
    @connector_name = @input.get('connector_name') # Name of the HTTP Connector
    @request_method = 'get' # HTTP Request Method
    @request_url = @input.get('url') # HTTP Request URL

    # optional
    @request_timeout = @input.get('timeout') # HTTP Request Timeout in milliseconds, taken
    # by the Connetor to serve the request
    @request_headers = @input.get('headers') # HTTP Request Headers

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | url :: #{@request_url} | method :: #{@request_method}")

    @log.trace('Calling HTTP Connector...')
    call_connector = @call.connector(@connector_name)
                          .set('method', @request_method)
                          .set('url', @request_url)
    # .timeout(10000)          #Execution time of the Flintbit in milliseconds

    response = if @request_timeout.to_s.empty?
                   call_connector.sync
               else
                   call_connector.set('timeout', @request_timeout).sync
               end

    # HTTP Connector Response Meta Parameters
    response_exitcode = response.exitcode # Exit status code
    response_message = response.message # Execution status message

    # HTTP Connector Response Parameters
    response_body = response.get('body') # Response Body
    response_headers = response.get('headers') # Response Headers

    if response.exitcode == 0
        @log.info("Success in executing HTTP Connector where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @log.info("HTTP Response Headers :: #{response_headers} | HTTP Response Body :: #{response_body}")
        @output.set('result', response_body)
        @log.trace("Finished executing 'get' flintbit with success...")
    else
        @log.error("Failure in executing HTTP Connector where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.set('error', response_message)
        @log.trace("Finished executing 'get' flintbit with error...")
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished execution 'flint-util:http:operation:get.rb' flintbit...")
# end
