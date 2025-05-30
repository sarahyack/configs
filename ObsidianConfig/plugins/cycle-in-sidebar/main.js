/*
THIS IS A GENERATED/BUNDLED FILE BY ROLLUP
if you want to view the source, please visit the github repository of this plugin
*/

'use strict';

var obsidian = require('obsidian');

class CycleInSidebarPlugin extends obsidian.Plugin {
    getLeavesOfSidebar(split) {
        const oneSideSplitRoot = split.getRoot();
        const leaves = [];
        this.app.workspace.iterateAllLeaves(l => { leaves.push(l); });
        const leavesInOneSide = leaves
            .filter(l => l.getRoot() === oneSideSplitRoot)
            .filter(l => l.view.getViewType() !== 'empty');
        if (leavesInOneSide.length == 0)
            return leaves;
        // filter only first container (if top/ bottom views)
        const parent = leavesInOneSide[0].parent;
        return leavesInOneSide.filter(l => l.parent == parent);
    }
    isSidebarOpen(split) {
        return this.getLeavesOfSidebar(split).some(l => l.view.containerEl.clientHeight > 0);
    }
    cycleInSideBar(split, offset) {
        const leaves = this.getLeavesOfSidebar(split);
        var currentIndex = 0;
        for (currentIndex = 0; currentIndex < leaves.length; currentIndex++) {
            if (leaves[currentIndex].view.containerEl.clientHeight > 0)
                break;
        }
        if (currentIndex == leaves.length)
            return;
        const nextIndex = ((currentIndex + offset) < 0 ? (leaves.length - 1) : (currentIndex + offset)) % leaves.length;
        this.app.workspace.revealLeaf(leaves[nextIndex]);
    }
    async cycleRightSideBar(offset) {
        this.cycleInSideBar(this.app.workspace.rightSplit, offset);
    }
    async cycleLeftSideBar(offset) {
        this.cycleInSideBar(this.app.workspace.leftSplit, offset);
    }
    async onload() {
        this.addCommand({
            id: 'cycle-right-sidebar',
            name: 'Cycle tabs of right sidebar',
            callback: () => { this.cycleRightSideBar(1); }
        });
        this.addCommand({
            id: 'cycle-right-sidebar-reverse',
            name: 'Cycle tabs of right sidebar in reverse',
            callback: () => { this.cycleRightSideBar(-1); }
        });
        this.addCommand({
            id: 'cycle-left-sidebar',
            name: 'Cycle tabs of left sidebar',
            callback: () => { this.cycleLeftSideBar(1); }
        });
        this.addCommand({
            id: 'cycle-left-sidebar-reverse',
            name: 'Cycle tabs of left sidebar in reverse',
            callback: () => { this.cycleLeftSideBar(-1); }
        });
    }
    onunload() {
    }
}

module.exports = CycleInSidebarPlugin;


/* nosourcemap */