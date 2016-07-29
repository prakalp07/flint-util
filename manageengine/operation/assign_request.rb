@log.trace("Started executing 'flint-util:operation:update-request.rb' flintbit...")
begin
                                # Flintbit Input Parameters
                                @connector_name = @input.get('connector_name')  # Name of the Manage Engine Connector
                                @action = 'assign-request'                      # Assign-Request be executed
                                @requestid = @input.get('requestid')            # Request-id of request
                                @technicianid = @input.get('technicianid')      # Technician-id of a technician

                                @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | action :: #{@action} | requestid :: #{@requestid} |
                                    technicianid :: #{@technicianid}")

                                @log.trace('Calling ManageEngine Connector...')

                                response = @call.connector(@connector_name)
                                                .set('action', @action)
                                                .set("request-id", @requestid)
                                                .set('technicianid', @technicianid)
                                                .sync
                                                
                                response_exitcode = response.exitcode       # Exit status code
                                response_message = response.message         # Execution status messages

                                response_body = response      # Response Body

                                if response_exitcode == 0
                                    @log.info("Success in executing manageenginesdp Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
                                    @log.info("Command executed :: #{@command} | Command execution results :: #{response_body}")
                                    @output.setraw('result', response_body.to_s)
                                    @log.trace("Finished executing 'manageenginesdp' flintbit with success...")
                                else
                                    @log.error("Failure in executing manageenginesdp Connector where, exitcode :: #{response_exitcode} | message :: #{response_message}")
                                    @output.set('error', response_message)
                                    @log.trace("Finished executing 'manageenginesdp' flintbit with error...")
                                end
                            rescue Exception => e
                                @log.error(e.message)
                                @output.set('exit-code', 1).set('message', e.message)
                            end
# end
