<!--- 

Special Thanks to Jason Dean (http://12robots.com/) and Pete Freitag (http://hackmycf.com/) for invaluable input.

CFUniForm will add a token to each form to aide you in preventing CSRF/XSRF attacks. Several settings exist to control the behavior. As you ratchet up the security, you increase the potential for undesirable behavior for users.

The Token Creator
-----------------------

-- DEFAULT BEHAVIOR --

- Token randomness and duration: By default, it will create a single token which will last for the duration of the browser's session. 

- Token storage: The token will be stored in the session scope if it is available, or the cookie scope if it is not.

- Token style: The token will be a SecureRandom, which provides both uniqueness and randomness. 
	By default, a new Java SecureRandom object will be created when the TokenCreator object is created, which is expensive (1-2 ms). 
	Getting a random number from the SecureRandom object is extremely fast. 
	Thus, again, it's best practice to create a single TokenCreator object in your application and pass that to CFUniForm. This approach will provide the best performance and security.

-- CUSTOMIZATION --

- Token randomness: You can use a token-per-form strategy by calling tokenCreator.setTokenGenerationPolicy("tokenPerForm"). This is only supported with session-based storage. Cookie based storage will always use a token per browser session

- Token duration: You can choose alternate strategies using tokenCreator.setTokenExpirationPolicy(). Options are:

		"onTokenTimeout", "onTokenCheck", "onSessionEnd" (default), "renewIfExisting"
		
		- onTokenTimeout: When the token times out (configured in the uform:form tag, defaulting to 30 minutes), a new token will be created
		
		- onTokenCheck: When a token check is called via tokenMatches( formToken, formID ), the saved token will be destroyed and a new one created
			NOTE: Using this approach, if the user hits the back button and resubmits, they token in their form will no longer be valid.
		
		- renewIfExisting: Only applicable to token-per-form generation. This is a middle ground between onSessionEnd and onTokenTimeout. 
			It will renew the token's expiration for this form if one exists. While it does increase the life of the token and therefore technically decreases security, it also decreases the likelihood that a user will be negatively affected when using the back button or going out to lunch prior to completing the form. 
			
			*NOTE: For a better user experience, when not using onSessionEnd we recommend this approach rather than onTokenTimeout

- Token storage: You can change the token storage provider by calling tokenCreator.setTokenStorageProvider( storageProviderObject ). CFUniForm ships with a TokenSessionStorageProvider and a TokenCookieStorageProvider. You can create your own if necessary.

- Token style: You can call tokenCreator.setTokenType("UUID") to have the object use UUID instead of SecureRandom. 
	
	This method is technically less secure in that UUIDs are not random, so the object will supplement the UUID with some randomness.
	
	Long-term, this method is slightly less performant than using SecureRandom when using a single object in your application. When using a new object per form, this method is faster.
	
	If you're in an environment where creating java objects is disabled, you will need to use this option instead of SecureRandom
 

	** If you want an alternate token style, subclass TokenCreator, override the makeTokenString() function, and set your token creator into the CFUniForm config


Your <uform:form...> tag
------------------------

Three attributes: TokenTimeout (default: 30 minutes), TokenFieldName (default: __cfu_token), and TokenCreator (default: a new TokenCreator object)

It is best practice to create a single TokenCreator object in your application (and the associated storage object) and set that into a config struct which you pass to CFUniForm.

Here's how to do that with ColdSpring:

<bean id="cfuniformTokenStorageProvider" class="cfuniform.TokenSessionStorageProvider"/>
	<bean id="cfuniformTokenCreator" class="cfuniform.TokenCreator">
		<property name="tokenStorageProvider"> <ref bean="cfuniformTokenStorageProvider"/> </property>
	</bean>
	<bean id="CFUniFormConfigBean" class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="SourceMap">
			<map>
				<entry key="tokenCreator"><ref bean="cfuniformTokenCreator"/></entry>
				<entry key="tokenFieldName"><value>__cfu_token_field</value></entry>
				....
				
</bean>

And then in your code:

<cfset cfUniformConfig = howeverYouGetObjectsFromColdSpringInYourApp()>

<uform:form action="yourAction.cfm"
		attributecollection="#cfUniformConfig#"
		id="activityEdit"
		...>
		
		....
</uform:form>

 --->
<cfcomponent>

	<cfset ON_TOKEN_TIMEOUT = "onTokenTimeout">
	<cfset ON_TOKEN_CHECK = "onTokenCheck">
	<cfset ON_SESSION_END = "onSessionEnd">
	<cfset RENEW_IF_EXISTING = "renewIfExisting">
		
	<cfset TOKEN_PER_FORM = "tokenPerForm">
	<cfset TOKEN_PER_SESSION = "tokenPerSession">
		
	<cfset UUID_TYPE = "uuid">
	<cfset SR_TYPE = "secureRandom">
	<cfset TOKEN_TYPE = SR_TYPE>
	<cfset secureRandom = "">
		
	<cfset TOKEN_PER_SESSION_KEY = "ALL">
	
	<cfset tokenGenerationPolicy = TOKEN_PER_SESSION>
	<cfset tokenExpirationPolicy = ON_SESSION_END> <!--- other possible values: onTokenCheck, onTokenTimeout, renewIfExisting --->
	
	
	<cfif sessionIsSupported()>
		<cfset tokenStorageProvider = createObject( "component", "TokenSessionStorageProvider")>
	<cfelse>
		<cfset tokenStorageProvider = createObject( "component", "TokenCookieStorageProvider")>
	</cfif>
    
    <cffunction name="setTokenExpirationPolicy" output="false" access="public"  returntype="void">    
    	<cfargument name="tokenExpirationPolicy" type="string" required="true"/>    
    	<cfset variables.tokenExpirationPolicy = arguments.tokenExpirationPolicy>    
    </cffunction>
    
    <cffunction name="setTokenGenerationPolicy" output="false" access="public"  returntype="void">    
    	<cfargument name="tokenGenerationPolicy" type="string" required="true"/>    
    	<cfset variables.tokenGenerationPolicy = arguments.tokenGenerationPolicy>    
    </cffunction>
    
    <cffunction name="setTokenStorageProvider" output="false" access="public" returntype="void">
    	<cfargument name="tokenStorageProvider" type="any" required="true"/>
		<cfset variables.tokenStorageProvider = arguments.tokenStorageProvider>
    </cffunction>
    
    <cffunction name="setTokenType" access="public" output="false" returntype="void">    
    	<cfargument name="tokenType" type="string" required="true"/>    
    	<cfset variables.tokenType = arguments.tokenType />    
    </cffunction>
    
    <cffunction name="saveToken" output="false" access="public" returntype="any" hint="stores the token into the storage scope. returns the token string value">
    	<cfargument name="formID" type="string" required="true"/>
		<cfargument name="token" type="string" required="true"/>
		<cfargument name="expiration" type="date" required="true"/>
		
		<cfreturn tokenStorageProvider.saveToken( formID, token, expiration )>
    </cffunction>
    
    <cffunction name="removeToken" output="false" access="public" returntype="any" hint="removes the token from the storage scope">    
    	<cfargument name="formID" type="string" required="true"/>
		
		<cfset tokenStorageProvider.removeToken( formID )>		
    </cffunction>
    
    <cffunction name="getSavedTokens" output="false" access="public" returntype="any" hint="returns the struct of saved tokens">    
    	<cfreturn tokenStorageProvider.getSavedTokens()>
    </cffunction>
    
    <cffunction name="getSavedToken" output="false" access="public" returntype="struct" hint="returns the token data for this formID">    
    	<cfargument name="formID" type="string" required="true"/>
    	
    	<cfset var tokens = getSavedTokens()>
    		
    	<cfif tokenGenerationPolicy eq TOKEN_PER_SESSION>
    		<cfset arguments.formID = TOKEN_PER_SESSION_KEY>
    	</cfif>
    	
    	<cfif structKeyExists( tokens, formID )>
    		<cfreturn tokens[formID]>
    	<cfelse>
    		<cfreturn getDefaultToken()>
    	</cfif>
    </cffunction>
	
	<cffunction name="generateToken" output="false" access="public" returntype="string" hint="returns a unique token for the form">   
		<cfargument name="formID" type="string" required="true"/> 
		<cfargument name="timeout" type="numeric" required="false" default="30"/>
		
    	<cfif tokenGenerationPolicy eq TOKEN_PER_SESSION>
    		<cfreturn generatePerSessionToken( formID, timeout )>
    	<cfelse>
    		<cfreturn generatePerFormToken( formID, timeout )>
    	</cfif>
    	
    </cffunction>	
    
    <cffunction name="generatePerSessionToken" output="false" access="public" returntype="string" hint="">    
    	<cfargument name="formID" type="string" required="true"/> 
		<cfargument name="timeout" type="numeric" required="false" default="30"/>
		
		<cfset var tokens = getSavedTokens()>

		<cfif not structKeyExists( tokens, TOKEN_PER_SESSION_KEY )>
			<cfreturn saveToken( TOKEN_PER_SESSION_KEY, makeTokenString(), dateAdd("n", arguments.timeout, now()) )>
		<cfelse>
			<cfreturn tokens[TOKEN_PER_SESSION_KEY].token>
		</cfif>
    </cffunction>
    
    <cffunction name="generatePerFormToken" output="false" access="public" returntype="string" hint="">    
    	<cfargument name="formID" type="string" required="true"/> 
		<cfargument name="timeout" type="numeric" required="false" default="30"/>
		
		<cfset var tokens = getSavedTokens()>
		<cfif structKeyExists( tokens, formID ) and tokenExpirationPolicy eq ON_SESSION_END>
			<cfreturn tokens[formID].token>
		<cfelseif structKeyExists( tokens, formID ) and tokenExpirationPolicy eq RENEW_IF_EXISTING>
			<!--- renew this form's token expiration --->
			<cfset tokens[formID].expiration = dateAdd("n", arguments.timeout, now())>
			<cfreturn tokens[formID]>
		<cfelse>
			<cfreturn saveToken( formID, makeTokenString(), expiration )>
		</cfif>
    </cffunction>
    
    <cffunction name="makeTokenString" output="false" access="private" hint="creates the actual token string">
    	
    	<cfif TOKEN_TYPE eq UUID_TYPE>
    		<cfreturn makeUUIDTokenString()>
    	<cfelse>
    		<cfreturn makeSecureRandomTokenString()>
    	</cfif>
    	
    </cffunction>
	
	<cffunction name="makeUUIDTokenString" output="false" access="private" returntype="string" hint="Creates a token string with UUID as its base">    
    	<cfreturn hash( createUUID() & rand( "SHA1PRNG" ), "SHA-256" )>
    </cffunction>

	<cffunction name="makeSecureRandomTokenString" output="false" access="public" returntype="string" hint="Creates a token string with a java SecureRandom as its base">    
    	<cfif isSimpleValue( variables.secureRandom )>
    		<cfset variables.secureRandom = createObject( "java", "java.security.SecureRandom" )>
    	</cfif>
    	<cfreturn hash( variables.secureRandom.nextLong(), "SHA-256" )>
    </cffunction>
    
    <cffunction name="sessionIsSupported" output="false" access="public" returntype="boolean" hint="whether the session scope is enabled">    
    	<cfset var settings = application.getApplicationSettings()>
    	<cfif structKeyExists( settings, "name" ) AND settings.sessionManagement>
    		<cfreturn true>
    	</cfif>
    	<cfreturn false>
    </cffunction>
    
    <cffunction name="getDefaultToken" output="false" access="private" returntype="struct" hint="returns an empty token struct">    
    	<cfset var defaultToken = structNew()>
    	<cfset defaultToken.formID = "">
		<cfset defaultToken.token = "">
		<cfset defaultToken.expiration = dateAdd("s", -1, now() )>
		<cfreturn defaultToken>
    </cffunction>
    
    <cffunction name="tokenMatches" output="false" access="public" returntype="any" hint="checks whether the token from the form matches the session token and has not expired">    
    	<cfargument name="formToken" type="string" required="true"/>
    	<cfargument name="formID" type="string" required="true"/>
		
		<cfset var matches = false>
		<cfset var savedToken = "">
		<cfset var compareToken = "">
			
		<cfif tokenExpirationPolicy eq ON_TOKEN_TIMEOUT>
			<cfset purgeExpiredTokens()>
		</cfif>
		
		<cfif tokenGenerationPolicy eq TOKEN_PER_SESSION>
    		<cfset arguments.formID = TOKEN_PER_SESSION_KEY>
    	</cfif>
		
		<cfset savedToken = getSavedToken( formID )>
		<cfset compareToken = savedToken.token>
		
		<!--- expired tokens would have been purged above, so no need to check here... in that case, 'compareToken' would be an empty string --->
		<cfif formToken eq compareToken AND compareToken neq "">
			<cfset matches = true>
		</cfif>
		
		<cfif tokenExpirationPolicy eq ON_TOKEN_CHECK>
			<cfset removeToken( formID )>
		</cfif>
		
		<cfreturn matches>
    </cffunction>
    
    <cffunction name="purgeExpiredTokens" output="false" access="public" returntype="any" hint="purges any expired tokens from the session">    
    	<cfset var formKey = "">
    	<cfset var tokens = getSavedTokens()>
    	<cfset var temp = duplicate( tokens )>
    		
    	<cfloop collection="#temp#" item="formKey">
    		<cfif dateCompare(now(), temp[formKey]["expiration"], "s" ) eq 1>
    			<cfset removeToken( formKey )>
    		</cfif>
    	</cfloop>
    	
    </cffunction>
    
</cfcomponent>