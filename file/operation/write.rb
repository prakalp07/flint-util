#begin
@log.trace("Started executing 'write' flintbit...")

#Flintbit Input Parameters
connector_name=@input.get("connector_name")      #Name of the HTTP Connector
action="write"  			         #Write Action
file_path=@input.get("file")                     #File Name and Location
data=@input.get("data")                          #Data to be written to the File

@log.info("Flintbit input parameters are, connector name :: #{connector_name} |
	                                  action ::         #{action} |
	                                  file_path ::      #{file_path} |
	                                  file_content ::   #{data}")

@log.trace("Calling File Connector...")
response=@call.connector(connector_name)
              .set("action",action)
              .set("file",file_path)
              .set("data",data)
              .sync
             

#File Connector Response Meta Parameters
response_exitcode=response.exitcode              #Exit status code
response_message=response.message                #Execution status messages


#File Connector Response Parameters
response_file=response.get("file")               #File, data is written to
response_body=response.get("body")               #Response Body, data written to the file

if response_exitcode == 0
	@log.info("Success in executing File Connector where, exitcode :: #{response_exitcode} |
		                                               message :: #{response_message}")
	@log.info("File :: #{response_file} | Data written to the file :: #{response_body}")
	@output.set("result",response_body)
	@log.trace("Finished executing 'write' flintbit with success...")

else
	@log.error("Failure in executing File Connector where, exitcode :: #{response_exitcode} |
		                                                message :: #{response_message}")
        @output.set("error",response_message)
        @log.trace("Finished executing 'write' flintbit with error...")

end
#end