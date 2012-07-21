<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfMgmtDemos/cfUniForm/demos/usingjQueryUICode.cfm
date created:	12/23/2010
author:			Matt Quackenbush (http://www.quackfuzed.com)
				
	// **************************************** LICENSE INFO **************************************** \\
	
	Copyright 2010, Matt Quackenbush
	
	Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in 
	compliance with the License.  You may obtain a copy of the License at 
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software distributed under the License is 
	distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
	implied.  See the License for the specific language governing permissions and limitations under the 
	License.
	
 --->

</cfsilent>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm - Using jQuery UI Tabs Demo - The Code</title>
</head>

<body>

<p>
	This page shows you the code used to generate the form 
	on the <a href="usingjQueryUI-tabs.cfm">Using jQuery UI Tabs demo page</a>.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="https://github.com/QuackFuzed/cfUniForm">Download cfUniForm from GitHub</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<cfoutput>
#htmlCodeFormat(replace('
	<script type="text/javascript">
		$(document).ready(function(){
			$("##tabs").tabs();
		});
	</script>

	<div id="tabs">
	<ul>
		<li><a href="##tabs-1">Login Details</a></li>
		<li><a href="##tabs-2">Contact Details</a></li>
	</ul>

	<div class="cfUniForm-form-container">
		<!--- 
			The opening tag demonstrates using the ''loadjQueryUI'' attribute set to true.
			When using jQuery UI, you *must* set ''configDateUI'' to true in order for your 
			datepickers to be loaded.
			
			Similarly, if you wish to use the jQuery UI based timepicker, you must also 
			set ''loadTimeUI'' (or ''configTimeUI'' if you have already loaded the time UI js)
			to true in order for the timepickers to be loaded.
		 --->
		<uform:form action="##cgi.script_name##"
					id="myDemoForm"
					submitValue=" Register "
					loadjQuery="true"
					loadjQueryUI="true"
					loadMaskUI="true"
					loadValidation="true">
			
			<uform:fieldset legend="Login Details" id="tabs-1">
				<uform:field label="User Name"
							name="username"
							isRequired="true"
							type="text"
							value="##form.username##"
							hint="" />
				
				<uform:field label="Password"
							name="userpassword"
							isRequired="true"
							type="password"
							value=""
							hint="" />
				
				<uform:field label="Confirm Password"
							name="confirmpassword"
							isRequired="true"
							type="password"
							value=""
							hint="Please re-enter your password to confirm it." />
			</uform:fieldset>
			<uform:fieldset legend="Contact Details" id="tabs-2">
				<uform:field label="Email Address"
							name="emailaddress"
							isRequired="true"
							type="text"
							value="##form.emailaddress##"
							hint="Please enter your *primary* email address." />
				
				<uform:field label="Confirm Email Address"
							name="confirmemailaddress"
							isRequired="true"
							type="text"
							value=""
							hint="Please re-enter your email address to confirm it." />
				
				<uform:field label="Phone Number"
							name="phone"
							isRequired="true"
							type="text"
							value="##form.phone##"
							mask="999.123.4567"
							hint="Please enter your phone number (e.g. 999.123.4567)" />
				
				<uform:field label="Fax Number"
							name="fax"
							isRequired="false"
							type="text"
							value="##form.fax##"
							mask="999.123.4567"
							hint="Please enter your phone number (e.g. 999.123.4567)" />
			</uform:fieldset>
		</uform:form>
	</div>
	</div>
' ,chr(9), " ", "all"))#
</cfoutput>

<hr />

<ul>
	<li><a href="usingjQueryUI-accordion.cfm">View the "Using jQuery UI tabs" demo form</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="https://github.com/QuackFuzed/cfUniForm">Download cfUniForm from GitHub</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>

