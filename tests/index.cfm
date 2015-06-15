<cfsilent>
<cfinvoke component="mxunit.runner.DirectoryTestSuite"
          method="run"
          directory="#expandPath('.')#"
          componentPath=""
          recurse="true"
          excludes=""
          returnvariable="results" />
</cfsilent>
<cfoutput>#results.getResultsOutput()#</cfoutput>
