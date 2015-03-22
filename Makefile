EMCC=emcc

# graphviz 2.36.0 d.d. 2014-01-11, patched
# (latest is 2.38.0 d.d. 2014-04-13, patched)
GRAPHVIZ_SRC_DIR=src/graphviz

# expat d.d. 2012-03-24
EXPAT_VERSION=2.1.0
EXPAT_SRC_DIR=src/libexpat-$(EXPAT_VERSION)

ZLIB_SRC_DIR=src/zlib
LIBSBC= \
	$(EXPAT_SRC_DIR)/lib/lib-em.bc \
	$(ZLIB_SRC_DIR)/libz-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/cdt/libcdt-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/common/libcommon-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/xdot/libxdot-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/dotgen/libdotgen-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/circogen/libcircogen-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/neatogen/libneatogen-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/twopigen/libtwopigen-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/patchwork/libpatchwork-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/osage/libosage-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/sparse/libsparse-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/pack/libpack-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/cgraph/libcgraph-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/fdpgen/libfdpgen-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/label/liblabel-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/gvc/libgvc-em.bc \
	$(GRAPHVIZ_SRC_DIR)/lib/pathplan/libpathplan-em.bc \
	$(GRAPHVIZ_SRC_DIR)/plugin/core/libgvplugin_core-em.bc \
	$(GRAPHVIZ_SRC_DIR)/plugin/dot_layout/libgvplugin_dot_layout-em.bc \
	$(GRAPHVIZ_SRC_DIR)/plugin/neato_layout/libgvplugin_neato_layout-em.bc
VIZOPTS=-v -O0 -g4 --llvm-opts 1 --llvm-lto 1 -s ASM_JS=1 --closure 1 --memory-init-file 0
LIBOPTS=-O0 -g4

viz.js: $(GRAPHVIZ_SRC_DIR) viz.c $(LIBSBC) post.js pre.js
	$(EMCC) $(VIZOPTS) -s EXPORTED_FUNCTIONS='["_vizRenderFromString"]' -o viz.js -I$(GRAPHVIZ_SRC_DIR)/lib/gvc -I$(GRAPHVIZ_SRC_DIR)/lib/common -I$(GRAPHVIZ_SRC_DIR)/lib/pathplan -I$(GRAPHVIZ_SRC_DIR)/lib/cdt -I$(GRAPHVIZ_SRC_DIR)/lib/cgraph -I$(EXPAT_SRC_DIR)/lib viz.c $(LIBSBC) --pre-js pre.js --post-js post.js

set_verbose_emscripten:
	$(eval VIZOPTS += -s VERBOSE=1)

verbose: set_verbose_emscripten viz.js

$(EXPAT_SRC_DIR)/lib/lib-em.bc: $(EXPAT_SRC_DIR)
	cd $(EXPAT_SRC_DIR)/lib; $(EMCC) $(LIBOPTS) -o lib-em.bc -I. -I.. -DHAVE_BCOPY -DHAVE_CONFIG_H xmlparse.c xmlrole.c xmltok.c

$(ZLIB_SRC_DIR)/libz-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(ZLIB_SRC_DIR); $(EMCC) $(LIBOPTS) -o libz-em.bc -D_LARGEFILE64_SOURCE=1 -DHAVE_HIDDEN -D_FILE_OFFSET_BITS=64 -I. adler32.c compress.c crc32.c deflate.c gzclose.c gzlib.c gzread.c gzwrite.c infback.c inffast.c inflate.c inftrees.c trees.c uncompr.c zutil.c

$(GRAPHVIZ_SRC_DIR)/lib/cdt/libcdt-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/cdt
	$(EMCC) $(LIBOPTS) -o libcdt-em.bc -DHAVE_CONFIG_H -I. -I../.. -I../../.. dtclose.c dtdisc.c dtextract.c dtflatten.c dthash.c dtlist.c dtmethod.c dtopen.c dtrenew.c dtrestore.c dtsize.c dtstat.c dtstrhash.c dttree.c dttreeset.c dtview.c dtwalk.c

$(GRAPHVIZ_SRC_DIR)/lib/common/libcommon-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/common; $(EMCC) $(LIBOPTS) -o libcommon-em.bc -DHAVE_CONFIG_H -DHAVE_EXPAT_H -DHAVE_EXPAT -I. -I.. -I../.. -I../../.. -I../gvc -I../pathplan -I../cdt -I../cgraph -I../fdpgen -I../label -I../xdot -I../../../$(EXPAT_SRC_DIR)/lib args.c arrows.c colxlate.c ellipse.c emit.c geom.c globals.c htmllex.c htmlparse.c htmltable.c input.c intset.c labels.c memory.c ns.c output.c pointset.c postproc.c psusershape.c routespl.c shapes.c splines.c taper.c textspan.c timing.c utils.c

$(GRAPHVIZ_SRC_DIR)/lib/xdot/libxdot-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/xdot; $(EMCC) $(LIBOPTS) -o libxdot-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../common -I../gvc -I../pathplan -I../cdt -I../cgraph xdot.c

$(GRAPHVIZ_SRC_DIR)/lib/dotgen/libdotgen-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/dotgen; $(EMCC) $(LIBOPTS) -o libdotgen-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../common -I../gvc -I../pathplan -I../cdt -I../cgraph acyclic.c aspect.c class1.c class2.c cluster.c compound.c conc.c decomp.c dotinit.c dotsplines.c fastgr.c flat.c mincross.c position.c rank.c sameport.c

$(GRAPHVIZ_SRC_DIR)/lib/circogen/libcircogen-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/circogen; $(EMCC) $(LIBOPTS) -o libcircogen-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../common -I../gvc -I../pathplan -I../cdt -I../cgraph -I../neatogen -I../sparse -I../pack block.c blockpath.c blocktree.c circpos.c circular.c circularinit.c deglist.c edgelist.c nodelist.c nodeset.c

$(GRAPHVIZ_SRC_DIR)/lib/neatogen/libneatogen-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/neatogen; $(EMCC) $(LIBOPTS) -o libneatogen-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../common -I../gvc -I../pathplan -I../cdt -I../cgraph -I../sparse -I../pack adjust.c bfs.c call_tri.c circuit.c closest.c compute_hierarchy.c conjgrad.c constrained_majorization.c constrained_majorization_ipsep.c constraint.c delaunay.c dijkstra.c edges.c embed_graph.c geometry.c heap.c hedges.c info.c kkutils.c legal.c lu.c matinv.c matrix_ops.c memory.c mosek_quad_solve.c multispline.c neatoinit.c neatosplines.c opt_arrangement.c overlap.c pca.c poly.c printvis.c quad_prog_solve.c quad_prog_vpsc.c site.c smart_ini_x.c solve.c stress.c stuff.c voronoi.c

$(GRAPHVIZ_SRC_DIR)/lib/twopigen/libtwopigen-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/twopigen; $(EMCC) $(LIBOPTS) -o libtwopigen-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../common -I../gvc -I../pathplan -I../cdt -I../cgraph -I../neatogen -I../sparse -I../pack circle.c twopiinit.c

$(GRAPHVIZ_SRC_DIR)/lib/patchwork/libpatchwork-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/patchwork; $(EMCC) $(LIBOPTS) -o libpatchwork-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../common -I../gvc -I../pathplan -I../cdt -I../cgraph -I../sparse -I../pack -I../fdpgen -I../neatogen patchwork.c patchworkinit.c tree_map.c

$(GRAPHVIZ_SRC_DIR)/lib/osage/libosage-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/osage; $(EMCC) $(LIBOPTS) -o libosage-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../common -I../gvc -I../pathplan -I../cdt -I../cgraph -I../sparse -I../pack -I../fdpgen -I../neatogen osageinit.c

$(GRAPHVIZ_SRC_DIR)/lib/sparse/libsparse-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/sparse; $(EMCC) $(LIBOPTS) -o libsparse-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../common -I../gvc -I../pathplan -I../cdt -I../cgraph BinaryHeap.c general.c IntStack.c SparseMatrix.c

$(GRAPHVIZ_SRC_DIR)/lib/pack/libpack-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/pack; $(EMCC) $(LIBOPTS) -o libpack-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../common -I../gvc -I../pathplan -I../cdt -I../cgraph -I../neatogen -I../sparse ccomps.c pack.c

$(GRAPHVIZ_SRC_DIR)/lib/cgraph/libcgraph-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/cgraph; $(EMCC) $(LIBOPTS) -o libcgraph-em.bc -DHAVE_STRCASECMP -DHAVE_CONFIG_H -I. -I../../.. -I../cdt -I../gvc -I../common -I../pathplan agerror.c agxbuf.c apply.c attr.c edge.c flatten.c grammar.c graph.c id.c imap.c io.c mem.c node.c obj.c pend.c rec.c refstr.c scan.c subg.c tester.c utils.c write.c

$(GRAPHVIZ_SRC_DIR)/lib/fdpgen/libfdpgen-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/fdpgen; $(EMCC) $(LIBOPTS) -o libfdpgen-em.bc -DHAVE_CONFIG_H -I. -I../../.. -I../cdt -I../gvc -I../common -I../pathplan -I../cgraph -I../neatogen -I../sparse -I../pack clusteredges.c comp.c dbg.c fdpinit.c grid.c layout.c tlayout.c xlayout.c

$(GRAPHVIZ_SRC_DIR)/lib/label/liblabel-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/label; $(EMCC) $(LIBOPTS) -o liblabel-em.bc -DHAVE_CONFIG_H -I. -I../cdt -I../gvc -I../cgraph -I../../.. -I../common -I../pathplan index.c node.c rectangle.c split.q.c xlabels.c

$(GRAPHVIZ_SRC_DIR)/lib/gvc/libgvc-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/gvc; $(EMCC) $(LIBOPTS) -o libgvc-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../../../zlib  -I../common -I../pathplan -I../cdt -I../cgraph gvbuffstderr.c gvc.c gvconfig.c gvcontext.c gvdevice.c gvevent.c gvjobs.c gvlayout.c gvloadimage.c gvplugin.c gvrender.c gvtextlayout.c gvusershape.c

$(GRAPHVIZ_SRC_DIR)/lib/pathplan/libpathplan-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/lib/pathplan; $(EMCC) $(LIBOPTS) -o libpathplan-em.bc -DHAVE_CONFIG_H -I. -I../../.. cvt.c inpoly.c route.c shortest.c shortestpth.c solvers.c triang.c util.c visibility.c

$(GRAPHVIZ_SRC_DIR)/plugin/core/libgvplugin_core-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/plugin/core; $(EMCC) $(LIBOPTS) -o libgvplugin_core-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../../lib -I../../lib/common -I../../lib/gvc -I../../lib/pathplan -I../../lib/cdt -I../../lib/cgraph gvplugin_core.c gvrender_core_dot.c gvrender_core_fig.c gvrender_core_map.c gvrender_core_ps.c gvrender_core_svg.c gvrender_core_tk.c gvrender_core_vml.c gvrender_core_pic.c gvrender_core_pov.c gvloadimage_core.c

$(GRAPHVIZ_SRC_DIR)/plugin/dot_layout/libgvplugin_dot_layout-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/plugin/dot_layout; $(EMCC) $(LIBOPTS) -o libgvplugin_dot_layout-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../../lib -I../../lib/common -I../../lib/gvc -I../../lib/pathplan -I../../lib/cdt -I../../lib/cgraph gvplugin_dot_layout.c gvlayout_dot_layout.c

$(GRAPHVIZ_SRC_DIR)/plugin/neato_layout/libgvplugin_neato_layout-em.bc: $(GRAPHVIZ_SRC_DIR)
	cd $(GRAPHVIZ_SRC_DIR)/plugin/neato_layout; $(EMCC) $(LIBOPTS) -o libgvplugin_neato_layout-em.bc -DHAVE_CONFIG_H -I. -I.. -I../.. -I../../.. -I../../lib -I../../lib/common -I../../lib/gvc -I../../lib/pathplan -I../../lib/cdt -I../../lib/cgraph gvlayout_neato_layout.c gvplugin_neato_layout.c

# prepare the graphviz src directory: patch
$(GRAPHVIZ_SRC_DIR):
	cd $(GRAPHVIZ_SRC_DIR)
	./autogen.sh

# prepare the expat src directory: download expat and expand
$(EXPAT_SRC_DIR): | expat-$(EXPAT_VERSION).tar.gz
	mkdir -p $(EXPAT_SRC_DIR)
	tar xf expat-$(EXPAT_VERSION).tar.gz -C $(EXPAT_SRC_DIR) --strip=1

# download expat
expat-$(EXPAT_VERSION).tar.gz:
	curl -L "http://sourceforge.net/projects/expat/files/expat/$(EXPAT_VERSION)/expat-$(EXPAT_VERSION).tar.gz/download" -o expat-$(EXPAT_VERSION).tar.gz

# remove all compiled and generated stuff, leaving downloaded stuff in place
clean:
	cd $(GRAPHVIZ_SRC_DIR); make clean
	rm -f $(GRAPHVIZ_SRC_DIR)/lib/*/*.bc
	rm -f $(GRAPHVIZ_SRC_DIR)/plugin/*/*.bc
	rm -f $(EXPAT_SRC_DIR)/lib/*.bc
	rm -f $(ZLIB_SRC_DIR)/*.bc
	rm -f viz.js*

# really reset everything, ready to start again
clobber: clean
	cd $(GRAPHVIZ_SRC_DIR); make maintainer-clean-am
	rm -rf $(EXPAT_SRC_DIR)
	rm -f *.tar.gz
