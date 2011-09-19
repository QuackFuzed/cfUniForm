<cfcomponent hint="Manages session-based csrf token storage">

	<cfset storageScopeKey = "cfuniform.csrftokens">
		
	<cffunction name="setStorageScopeKey" output="false" access="public" returntype="any" hint="">    
    	<cfargument name="storageScopeKey" type="string" required="true"/>
		<cfset variables.storageScopeKey = arguments.storageScopeKey>
    </cffunction>
		
	<cffunction name="getSavedTokens" output="false" access="public" returntype="any" hint="returns the struct of saved tokens">    
		<cfif not structKeyExists( cookie, storageScopeKey )>
			<cfreturn structNew()>
		<cfelse>
			<cfreturn deserializeJson( cookie[storageScopeKey] )>
		</cfif>  	
    </cffunction>
    
     <cffunction name="saveToken" output="false" access="public" returntype="any" hint="stores the token into the storage scope. returns the token string value">
    	<cfargument name="formID" type="string" required="true"/>
		<cfargument name="token" type="string" required="true"/>
		<cfargument name="expiration" type="date" required="true"/>
		
		<cfset var tokenData = structNew()>
		<cfset tokenData[formID] = arguments>
		<cfcookie name="#storageScopeKey#" httponly="true" value="#serializeJson(tokenData)#">
		
    	<cfreturn token>
    </cffunction>
    
    <cffunction name="removeToken" output="false" access="public" returntype="any" hint="removes the token from the storage scope">    
    	<cfargument name="formID" type="string" required="true"/>
		
		<cfset structDelete( cookie, storageScopeKey )>
		
    </cffunction>
	
</cfcomponent>