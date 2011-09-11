<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfsilent>
<!--- 
filename:		cfUniForm/demos/usingjQueryUI.cfm
date created:	12/19/2010
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
	
	// ****************************************** REVISIONS ****************************************** \\
	
 --->

<!--- 
	FOR MORE DETAILS ON USAGE, SEE MY BLOG AT http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library
	
	YOU CAN ALSO VIEW THE 'use example' COMMENTS AT THE TOP OF EACH OF THE TAG FILES LOCATED IN THE 
	/tags/forms/cfUniForm/ DIRECTORY.
 --->

<!--- import the tag library --->
<cfimport taglib="/tags/forms/cfUniForm" prefix="uform" />

<!--- param our form variables --->
<cfparam name="form.task" type="string" default="" />
<cfparam name="form.description" type="string" default="" />
</cfsilent>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="/demos/assets/css/demostyles.css" type="text/css" rel="stylesheet" media="all" />
	<title>cfUniForm Using jQuery UI Dates &amp; Times Demo</title>
</head>

<body>

<p>
	This page displays the "Using jQuery UI" demo form.
	View the 
	<a href="usingjQueryUI-datesandtimesCode.cfm">code used to generate the form</a>.
</p>
<p>
			When using jQuery UI, you *must* set 'configDateUI' to true in order for your 
			datepickers to be loaded.
</p>
<p>
			Similarly, if you wish to use the jQuery UI based timepicker, you must also 
			set 'loadTimeUI' (or 'configTimeUI' if you have already loaded the time UI js)
			to true in order for the timepickers to be loaded.
</p>
<p class="highlight">
	NOTE: By default, cfUniForm will load the full jQuery UI from Google APIs.  If for some 
	reason you have changed this behavior, please note that you *must* have the UI datepicker 
	module included in your code, along with any dependencies.
</p>
<ul>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="https://github.com/QuackFuzed/cfUniForm">Download cfUniForm from GitHub</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

<hr />

<div id="wrap">
	<div class="cfUniForm-form-container">
		<!--- 
			The opening tag demonstrates using the 'loadjQueryUI' attribute set to true.
			When using jQuery UI, you *must* set 'configDateUI' to true in order for your 
			datepickers to be loaded.
			
			Similarly, if you wish to use the jQuery UI based timepicker, you must also 
			set 'loadTimeUI' (or 'configTimeUI' if you have already loaded the time UI js)
			to true in order for the timepickers to be loaded.
		 --->
		<uform:form action="#cgi.script_name#"
					id="myDemoForm"
					submitValue=" Add Task "
					loadjQuery="true"
					loadjQueryUI="true"
					configDateUI="true"
					configTimestampUI="true"
					loadTimeUI="true">
			
			<uform:fieldset legend="Task Details">
				<uform:field label="Task Name"
							name="task"
							isRequired="true"
							type="text"
							value="#form.task#"
							hint="Enter a name to remember your task by (e.g. Pick up laundry)" />
				
				<uform:field label="Start Date"
							name="startDate"
							isRequired="true"
							type="date" />
				
				<uform:field label="Start Time"
							name="startTime"
							isRequired="true"
							type="time" />
				
				<!--- 
					Here we use the 'pluginSetup' attribute on our field to change the behavior of this particular datepicker.
					This one shows the week number and changes the trigger image.
				 --->
				<uform:field label="End Date"
							name="endDate"
							isRequired="true"
							type="date"
							pluginSetup="{showWeek:true,buttonImage:'../assets/images/calendar.gif'}" />
				
				<!--- 
					Here we use the 'pluginSetup' attribute on our field to change the behavior of this particular timepicker.
					We are using AM/PM and changing the trigger image.
				 --->
				<uform:field label="End Time"
							name="endTime"
							isRequired="true"
							type="time"
							pluginSetup="{
										ampm:true,
										buttonImage:'/commonassets/images/uni-form/clock_red.png'}" />
				
				<uform:field label="A Timestamp"
							name="timestamp"
							isRequired="true"
							type="timestamp" />
				
				<uform:field label="Detailed Description"
							name="description"
							isRequired="true"
							type="textarea"
							value="#form.description#"
							hint="Enter a detailed description of the task (e.g. directions to the cleaners)." />
			</uform:fieldset>
		</uform:form>
	</div>
</div>

<hr />

<ul>
	<li><a href="usingjQueryUI-datesandtimesCode.cfm">View the code</a></li>
	<li><a href="index.cfm">Back to the cfUniForm demo home</a></li>
	<li><a href="https://github.com/QuackFuzed/cfUniForm">Download cfUniForm from GitHub</a></li>
	<li><a href="http://www.quackfuzed.com/index.cfm/UniForm-Tag-Library">View my blog</a></li>
</ul>

</body>
</html>
