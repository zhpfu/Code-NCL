load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"      	
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"      
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"     

in1 = addfile("case1.nc","r")
in2 = addfile("case2.nc","r")
in3 = addfile("case3.nc","r")

ice1=in1->ice_cov
ice2=in2->ice_cov
ice12			=	ice1(11,:,:)
ice11			=	ice1(0:10,:,:)
ice1(1:11,:,:)	=	ice11
ice1(0,:,:)		=	ice12
iceice12			=	ice2(11,:,:)
iceice11			=	ice2(0:10,:,:)
ice2(1:11,:,:)	=	iceice11
ice2(0,:,:)		=	iceice12

sst1=in2->SST_cpl
sst12			=	sst1(11,:,:)
sst11			=	sst1(0:10,:,:)
sst1(1:11,:,:)	=	sst11
sst1(0,:,:)		=	sst12

sst2=in3->SST_cpl
sstsst12			=	sst2(11,:,:)
sstsst11			=	sst2(0:10,:,:)
sst2(1:11,:,:)	=	sstsst11
sst2(0,:,:)		=	sstsst12

idif = ice2-ice1
sdif = sst2-sst1

copy_VarCoords(ice2,idif)
copy_VarCoords(sst2,sdif)

i1 = dim_avg_n_Wrap(ice1(0:2,:,:),0)
i2 = dim_avg_n_Wrap(ice1(3:5,:,:),0)
i3 = dim_avg_n_Wrap(ice1(6:8,:,:),0)
i4 = dim_avg_n_Wrap(ice1(9:11,:,:),0)

idif1 = dim_avg_n_Wrap(idif(0:2,:,:),0)
idif2 = dim_avg_n_Wrap(idif(3:5,:,:),0)
idif3 = dim_avg_n_Wrap(idif(6:8,:,:),0)
idif4 = dim_avg_n_Wrap(idif(9:11,:,:),0)

sdif1 = dim_avg_n_Wrap(sdif(0:2,:,:),0)
sdif2 = dim_avg_n_Wrap(sdif(3:5,:,:),0)
sdif3 = dim_avg_n_Wrap(sdif(6:8,:,:),0)
sdif4 = dim_avg_n_Wrap(sdif(9:11,:,:),0)

 a    = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
 lsdata = a->LSMASK
 lsm  = landsea_mask(lsdata,i1&lat,i1&lon)
i1 = where(lsm.ne.0,0,i1)
i2 = where(lsm.ne.0,0,i2)
i3 = where(lsm.ne.0,0,i3)
i4 = where(lsm.ne.0,0,i4)
ice=True
ice@gsnLeftString  =  ""
ice@gsnCenterString = ""
ice@gsnRightString = ""
ice@cnLevelSelectionMode = "ManualLevels"
ice@cnMinLevelValF=0
ice@cnMaxLevelValF=1.00
ice@cnLevelSpacingF = 0.10
ice@cnFillOn = True
ice@gsnSpreadColors = True
ice@gsnPolar    = "NH"
ice@mpMinLatF = 45
ice@gsnDraw=False
ice@gsnFrame=False 
ice@gsnSpreadColorStart = 10
ice@gsnSpreadColorEnd 	= 1
ice@lbLabelBarOn		=False
ice@cnLinesOn=False
wks = gsn_open_wks("eps","ice")
gsn_define_colormap(wks,"CBR_wet")
plot=new(4,graphic)
resP = True
plot(0)=gsn_csm_contour_map_polar(wks,i1,ice)
plot(1)=gsn_csm_contour_map_polar(wks,i2,ice)
plot(2)=gsn_csm_contour_map_polar(wks,i3,ice)
plot(3)=gsn_csm_contour_map_polar(wks,i4,ice)
resP@gsnMaximize  = True
resP@gsnPanelLabelBar=True
;resP@lbOrientation=Vertical
;resP@lbLabelPosition = Top
gsn_panel(wks,plot,(/1,4/),resP)

