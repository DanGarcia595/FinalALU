
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name FinalALU -dir "/home/bobby/DigitalDesign/FinalALU/planAhead_run_2" -part xc3s500efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/bobby/DigitalDesign/FinalALU/FinalBehavior.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/bobby/DigitalDesign/FinalALU} }
set_property target_constrs_file "/home/bobby/DigitalDesign/FinalALU/Lab 2/SevenSegmentDisplay/SevenSeg_toplevel.ucf" [current_fileset -constrset]
add_files [list {/home/bobby/DigitalDesign/FinalALU/Lab 2/SevenSegmentDisplay/SevenSeg_toplevel.ucf}] -fileset [get_property constrset [current_run]]
link_design
