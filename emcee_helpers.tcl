# helper functions for emcee_xspec
# Jeremy Sanders 2012

set HDR "@@EMCEE@@"

# startup
proc emcee_startup {} {
    puts "Running emcee startup script"
    autosave off
    chatter 1
}

# get list of components and parameters
proc emcee_interrogate_params {} {
    global HDR
    puts $HDR

    # return component information
    puts [tcloutr modcomp]
    for {set i 1} {$i <= [tcloutr modcomp]} {incr i} {
	puts [tcloutr compinfo $i]
    }

    # return parameter information
    puts [tcloutr modpar]
    for {set i 1} {$i <= [tcloutr modpar]} {incr i} {
	puts [tcloutr pinfo $i]
	puts [tcloutr plink $i]
	puts [tcloutr param $i]
    }
    puts $HDR
}

# set parameters
proc emcee_set_params { args } {
    set length [llength $args]

    model unnamed inactive
    for { set i 0 } { $i < $length } {incr i 2} {
	newpar [lindex $args $i] [lindex $args [expr $i+1]]
    }
    model unnamed active
}

# get statistic
proc emcee_statistic { } {
    global HDR
    puts "$HDR [tcloutr stat] $HDR"
}

# loop taking parameters and returning results
# exits when quit is entered or stdin closes
proc emcee_loop { } {
    fconfigure stdin -buffering line
    fconfigure stdout -buffering line

    while { 1 } {

	set line [gets stdin]

	if { [eof stdin] } {
	    tclexit
	}

	if { $line == "quit" } {
	    tclexit
	}

	eval emcee_set_params $line
	emcee_statistic
    }

}

emcee_startup
