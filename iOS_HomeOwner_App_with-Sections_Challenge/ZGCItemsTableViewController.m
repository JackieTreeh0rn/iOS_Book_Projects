//
//  ZGCItemsTableViewController.m
//  iOS_HomeOwner_App
//
//  Created by EvilKernel on 4/4/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCItemsTableViewController.h"
#import "ZGCItemStore.h"
#import "ZGCItem.h"

@interface ZGCItemsTableViewController ()

@end

@implementation ZGCItemsTableViewController

/* Changing designated initializer to "init" (default is initWithStyle:)
 then will override superclass' designated initializer to call this one */
- (instancetype)init {
    // Call superclass designated initializer (rule)
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[ZGCItemStore sharedStore] createItem]; // initiates store, create 5 items
        }
    }
    return self;
}

/* Overriding superclass designated initializer to call mine */
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init]; // all instances will now use plainviewstyle
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* This is required to tell the tableview which kind of cell
     it should instantiate if there are no cells in the reuse pool
     when cellForView protocol method is called */
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    
    self.tableView.rowHeight = 60;

    self.tableView.sectionFooterHeight = 44;
    self.tableView.sectionHeaderHeight = 60;
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section. equals n. of items in array
    
    // return [[[ZGCItemStore sharedStore] allItems] count];
    
    NSArray *items = [[ZGCItemStore sharedStore] allItems];
    int sum = 0;
    if (section == 0) {
        for (ZGCItem *i in items) {
            if (i.valueInDollars > 50.0) {
                sum++;
            }
        }
    }
    
    if (section == 1) {
        for (ZGCItem *i in items) {
            if (i.valueInDollars < 50.0) {
                sum++;
            }
        }
    }
    
    return sum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     // Create an instance of UITableViewCell, with default apperance
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
     */
    

    // Using conventional method to create UITableViewCell object via resuable indent.
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    // Set the text on the cell with the descripton of the item
    // that is at the nth index of items (n = row this cell will appear on)
    NSArray *items = [[ZGCItemStore sharedStore] allItems];
    
    // BRONZE CHALLENGE // -- using 2 sections, one for items > $50 bucks / one for <.
    // Define two arrays to store rows (items) for each section
    NSMutableArray *section0 = [[NSMutableArray alloc] init];
    NSMutableArray *section1 = [[NSMutableArray alloc] init];
    
    
    for (ZGCItem *i in items) {
        if (i.valueInDollars > 50.0) {
            [section0 addObject:i];
        } else {
            [section1 addObject:i];
        }
    }
    
    if (indexPath.section == 0) {
        ZGCItem *item = section0[indexPath.row];
        cell.textLabel.text = [item description];
        
    } else if (indexPath.section == 1) {
        ZGCItem *item = section1[indexPath.row];
        cell.textLabel.text = [item description];
    }
    
    return cell;
    

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - tableview delegate methods
/// SILVER CHALLENGE /// - footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    footer.textLabel.text = @"No more items";
    
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    header.contentView.backgroundColor = [UIColor lightGrayColor];
    
    if (section == 0) {
        header.textLabel.text = @"Items > $50";
    }
    if (section == 1) {
    header.textLabel.text = @"Items < $50";
    }
    
    return header;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
