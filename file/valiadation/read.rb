#begin
@log.trace("Started executing 'read' flintbit...")

#Flintbit Input Parameters
connector_name=@input.get("connector_name")      #Name of the File Connector
action=@input.get("action")                      #Action
file_path=@input.get("file")                     #File Name and File Location

if connector_name.nil? || connector_name.empty?
   connector_name="file"
end
if action.nil? || action.empty?
   action="read"
end
if file_path.nil? || file_path.empty?
   file_path=ENV['HOME']+"/flint-dist/flintbox/flint-test-workpackage/file/validations/Sample.txt"
end



@log.info("Flintbit input parameters are, connector name :: #{connector_name} |
	                                  action ::         #{action} |
	                                  file_path ::      #{file_path}")

@log.trace("Calling File Connector...")

response=@call.connector(connector_name)
              .set("action",action)
              .set("file",file_path)
              .sync
              

#File Connector Response Meta Parameters
response_exitcode=response.exitcode             #Exit status code
response_message=response.message               #Execution status messages


#File Connector Response Parameters
response_file=response.get("file")              #File read
response_body=response.get("body")              #Response Body, data read from the file

if response_exitcode == 0
	@log.info("Success in executing File Connector where, exitcode :: #{response_exitcode} |
		                                               message :: #{response_message}")
	@log.info("File read :: #{response_file} | Data read from the File ::#{response_body}")
	@output.set("result",response_body)
	@log.trace("Finished executing 'read' flintbit with success...")
else
	@log.error("Failure in executing File Connector where, exitcode :: #{response_exitcode} |
		                                                message :: #{response_message}")
        @output.set("error",response_message)
        @log.trace("Finished executing 'read' flintbit with error...")
end

#end