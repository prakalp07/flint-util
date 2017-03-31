require 'json'
begin
	@log.trace("Started execution of 'flint-util:jenkins:start_build.rb' flintbit..")
	@jenkins_username = @config.global("jenkins_build.username") # Username of the jenkins user
	@jenkins_api_token= @config.global("jenkins_build.apitoken") #Api token of Jenkins
	@jenkins_host= @config.global("jenkins_build.jenkins_host")  #Jenkins host URL
	@lastSuccessfulBuild = @config.global("jenkins_build.last_successful_build_url")
  @crumburl = @config.global("jenkins_build.crumb_url")
	@id = @input.get('id')
	@mention_name = @input.get('mention_name')          # Name of chat tool user
	@build_name = @input.get('build_name')

	if @build_name.include? " "
		@status_url = @jenkins_host << @build_name.gsub!(" ", "%20") << @lastSuccessfulBuild
		@build_name.gsub!("%20", " ")
	else
		@status_url = @jenkins_host << @build_name << @lastSuccessfulBuild
	end
  @concatenate_string = @jenkins_username << ":" << @jenkins_api_token

	@encoded_string = @util.encode64(@concatenate_string)

	@concatenate_authorization = "Basic" << " " << @encoded_string

	response_crumb=@call.connector("http")
              .set("method", "GET")
              .set("url",@crumburl)
              .set("headers","Authorization:#{@concatenate_authorization}")
              .set("body","abc")
              .set("timeout",300000)
              .sync

	@exitcode = response_crumb.exitcode
	@crum_message = response_crumb.message


	response_crumb_body=response_crumb.get("body")
	response_body1 =@util.json(response_crumb_body)         #Response Body

	@crumb = response_body1.get("crumb")
	@log.info("crumbLastBuild::: #{@crumb}")
	if @exitcode == 0
		response_buildstatus= @call.connector("http")
              .set("method", "GET")
              .set("url",@status_url)
              .set("headers","Authorization:#{@concatenate_authorization}")
              .set("body","abc")
              .set("timeout",300000)
              .sync
		response_body=response_buildstatus.get("body")           #Response Body

	else
		@log.error("message : #{@crum_message}")
	end
	@buildstatus_exitcode = response_buildstatus.exitcode
	@buildstatus_message = response_buildstatus.message

	responseJson = @util.json(response_body)
	@responseResult = responseJson.get('result')
	@responseFullDisplayName = responseJson.get('fullDisplayName')
	@responseUrl = responseJson.get('url')

	if @buildstatus_exitcode == 0

		@log.info("Success in getting last build status ")
		@reply_message = 'Hello @' + @mention_name + ',Build status is : '+ @responseResult + ' |Full Build-name: ' + @responseFullDisplayName + ' |Build URL: ' + @responseUrl
		@output.set("reply_message",@reply_message)
	else
		@log.error("message : #{@buildstatus_message}")
		@reply_message = 'Hello @' + @mention_name + ',Failed in getting build status of: ' + @build_name +
		@output.set("reply_message",@reply_message)
	end
rescue Exception => e
	@log.error(e.message)
	@reply_message = 'Hello @' + @mention_name + ',Failed in getting build status of: ' + @build_name + ' due to ' + e.message + ''
	@output.set('exit-code', 1).set('message', e.message).set("reply_message",@reply_message)
end
@log.trace("Finished execution of 'flint-util:jenkins:start_build.rb' flintbit..")
