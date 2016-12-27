# begin
@log.trace("Started executing 'SalesForce:create.rb' flintbit...")
begin
    # Flintbit Input Parameters
    @connector_name = @input.get('connector_name') # Name of the Salesforce Connector
    if @connector_name.nil?
        @connector_name = 'salesforce'
    end
    @action = 'create-record'                     # Contains the name of the operation: list
    @sobject = 'Case'
    @data = @input.get('data')


    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} |action :: #{@action}| sobject :: #{@sobject}")

          response = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('sobject', @sobject)
                          .set('data', @data)
                          .sync

    # Salesforce Connector Response Meta Parameters
    response_exitcode = response.exitcode           # Exit status code
    response_message = response.message             # Execution status message

    # Salesforce Connector Response Parameters
    response_body = response.get('body')            # Response body
    @log.info("#{response_body}")
    if response_exitcode == 0  
        @log.info("Success in executing SalesForce Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.setraw('result', response_body)
        @log.trace("Finished executing 'SalesForce' flintbit with success...")
    else
        @log.error("Failure in executing SalesForce Connector where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.set('error', response_message)
        @log.trace("Finished executing 'SalesForce' flintbit with error...")
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'SalesForce:create.rb' flintbit...")
# end