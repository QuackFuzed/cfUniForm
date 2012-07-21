<cfcomponent hint="Manages session-based csrf token storage">

	<cfset storageScopeKey = "cfuniform.csrftokens">
		
	<cffunction name="setStorageScopeKey" output="false" access="public" returntype="any" hint="">    
    	<cfargument name="storageScopeKey" type="string" required="true"/>
		<cfset variables.storageScopeKey = arguments.storageScopeKey>
    </cffunction>
		
	<cffunction name="getSavedTokens" output="false" access="public" returntype="any" hint="returns the struct of saved tokens">    
		<cfif not structKeyExists( session, storageScopeKey )>
			<cfset session[storageScopeKey] = structNew()>
		</cfif>
		<cfreturn session[storageScopeKey]>    	
    </cffunction>
    
     <cffunction name="saveToken" output="false" access="public" returntype="any" hint="stores the token into the storage scope. returns the token string value">
    	<cfargument name="formID" type="string" required="true"/>
		<cfargument name="token" type="string" required="true"/>
		<cfargument name="expiration" type="date" required="true"/>
		
		<cfset session[storageScopeKey][formID] = arguments>
		
    	<cfreturn token>
    </cffunction>
    
    <cffunction name="removeToken" output="false" access="public" returntype="any" hint="removes the token from the storage scope">    
    	<cfargument name="formID" type="string" required="true"/>
		
		<cfset structDelete( session[storageScopeKey], formID )>
		
    </cffunction>
	
</cfcomponent>